resource "aws_launch_template" "eb_launch_template" {
  name = "eb-launch-template"

  user_data = base64encode(<<-EOT
  #!/bin/bash
  yum update -y
  yum install -y postgresql

  # get RDS connect information
  RDS_HOST="${local.rds_endpoint}"
  DB_PASSWORD="${local.rds_password}"
  DB_CLUSTER_IDENTIFIER="${local.rds_dbClusterIdentifier}"
  DB_SECRET_ARN="${local.rds_secret_arn}"

  # create database
  PGPASSWORD=$DB_PASSWORD psql -h $RDS_HOST -U $DB_USER -c "CREATE DATABASE idea_box_db;"

  sed -i 's/listen 5000;/listen 8080;/' /etc/nginx/nginx.conf
  systemctl restart nginx
  EOT
  )

  iam_instance_profile {
    name = "aws-elasticbeanstalk-ec2-role"
  }

  key_name = "ideabox"
}


resource "aws_lambda_function" "create_database" {
  function_name    = "create_database"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.8"

  s3_bucket        = "idea-box-terraform"
  s3_key           = "lambda.zip"

  environment {
    variables = {
      DB_HOST     = local.rds_endpoint
      DB_PASSWORD = local.rds_password
    }
  }
}

resource "aws_cloudwatch_event_rule" "eb_start_event_rule" {
  name        = "eb-start-event"
  description = "Triggers Lambda function when Elastic Beanstalk environment starts"
  event_pattern = jsonencode({
    "source" = ["aws.elasticbeanstalk"],
    "detail-type" = ["ElasticBeanstalk Environment State Change"],
    "detail" = {
      "state" = ["Ready"]
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.eb_start_event_rule.name
  target_id = "CreateDatabaseTarget"
  arn       = aws_lambda_function.create_database.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowCloudWatchInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  function_name = aws_lambda_function.create_database.function_name
}



resource "aws_security_group" "eb_sg" {
  name        = "eb-sg"
  description = "Elastic Beanstalk EC2 Security Group"
  vpc_id      = "vpc-0241f7fffff83ad0d"
}

resource "aws_security_group_rule" "eb_to_rds" {
  type                        = "ingress"
  from_port                   = 5432
  to_port                     = 5432
  protocol                    = "tcp"
  security_group_id           = local.rds_security_group_id
  source_security_group_id    = aws_security_group.eb_sg.id
}

resource "aws_elastic_beanstalk_application" "backend" {
  name        = "idea-box-backend"
  description = "Elastic Beanstalk Application for Idea Box Backend"
}

resource "aws_elastic_beanstalk_application_version" "backend_app_version" {
  application = aws_elastic_beanstalk_application.backend.name
  name        = "v1"
  bucket      = "idea-box-terraform"
  key         = "backend.zip"
  force_delete = true
}

resource "aws_elastic_beanstalk_environment" "idea_box_back" {
  name                = "idea-box-backend"
  application         = aws_elastic_beanstalk_application.backend.name
  version_label       = aws_elastic_beanstalk_application_version.backend_app_version.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.4.1 running Corretto 17"

  setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "IamInstanceProfile"
      value = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_SECRET_ARN"
    value     = aws_secretsmanager_secret.idea_box_bck_creds.arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CONITO_CREDS_ARN"
    value     = aws_secretsmanager_secret.conito_creds.arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_REGION"
    value     = "eu-west-3"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "LOG_LEVEL"
    value     = "INFO"
  }

  wait_for_ready_timeout = "30m"
}