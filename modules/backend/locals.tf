data "aws_ssm_parameter" "rds_secret_arn" {
  name = "/idea-box/rds-secret-arn"
}

data "aws_ssm_parameter" "rds_endpoint" {
  name = "/idea-box/rds-endpoint"
}

data "aws_ssm_parameter" "rds_dbClusterIdentifier" {
  name = "/idea-box/rds-dbClusterIdentifier"
}

data "aws_ssm_parameter" "rds_password" {
  name            = "/idea-box/rds-password"
  with_decryption = true
}

locals {
  rds_secret_arn          = data.aws_ssm_parameter.rds_secret_arn.value
  rds_endpoint            = data.aws_ssm_parameter.rds_endpoint.value
  rds_dbClusterIdentifier = data.aws_ssm_parameter.rds_dbClusterIdentifier.value
  rds_password            = data.aws_ssm_parameter.rds_password.value
}