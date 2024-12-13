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

data "aws_ssm_parameter" "rds_security_group_id" {
  name = "/idea-box/aws-security-group"
}

locals {
  rds_secret_arn          = data.aws_ssm_parameter.rds_secret_arn.value
  rds_endpoint            = data.aws_ssm_parameter.rds_endpoint.value
  rds_dbClusterIdentifier = data.aws_ssm_parameter.rds_dbClusterIdentifier.value
  rds_password            = data.aws_ssm_parameter.rds_password.value
  rds_security_group_id = data.aws_ssm_parameter.rds_security_group_id.value
}

# locals {
#   rds_secret_arn            = "default_secret_arn"
#   rds_endpoint              = "default_endpoint"
#   rds_dbClusterIdentifier   = "default_dbClusterIdentifier"
#   rds_password              = "default_password"
#   rds_security_group_id     = "default_security_group_id"
# }
