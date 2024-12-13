resource "aws_iam_policy" "secret_manager_access" {
  name        = "SecretManagerAccessPolicy"
  description = "Allow Elastic Beastalk EC2 role to access Secret Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = [
          aws_secretsmanager_secret.idea_box_bck_creds.arn,
          aws_secretsmanager_secret.conito_creds.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attache_secrets_manager_policy" {
  role       = "aws-elasticbeanstalk-ec2-role"
  policy_arn = aws_iam_policy.secret_manager_access.arn
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "ElasticBeanstalkS3AccessPolicy"
  description = "Allow Elastic Beanstalk EC2 instance to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "S3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::idea-box-terraform",
          "arn:aws:s3:::idea-box-terraform/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attache_s3_access_policy" {
  role       = "aws-elasticbeanstalk-ec2-role"
  policy_arn = aws_iam_policy.s3_access_policy.arn
}



################################
#lambda
resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_rds_policy" {
  name   = "lambda-rds-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "rds:DescribeDBInstances",
          "rds:ModifyDBInstance",
          "rds:CreateDBInstance"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attache_lambda_rds_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_rds_policy.arn
}
