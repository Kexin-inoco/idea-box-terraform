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

resource "aws_elastic_beanstalk_application" "backend" {
  name        = "idea-box-backend"
  description = "Elastic Beanstalk Application for Idea Box Backend"
}

resource "aws_elastic_beanstalk_application_version" "backend_app_version" {
  application = aws_elastic_beanstalk_application.backend.name
  name        = "v1"
  bucket      = "idea-box-terraform"
  key         = "ideabox-0.0.1-SNAPSHOT.jar"
}

resource "aws_elastic_beanstalk_environment" "idea_box_back" {
  name                = "idea-box-backend"
  application         = aws_elastic_beanstalk_application.backend.name
  version_label       = aws_elastic_beanstalk_application_version.backend_app_version.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.4.1 running Corretto 17"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "LaunchTemplate"
    value     = aws_launch_template.eb_launch_template.id
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
}