resource "aws_ssm_parameter" "rds_recret_arn" {
  name = "/idea-box/rds-secret-arn"
  type = "String"
  value = aws_db_instance.idea_box_rds.master_user_secret[0].secret_arn
}

resource "aws_ssm_parameter" "rds_endpoint" {
  name = "/idea-box/rds-endpoint"
  type = "String"
  value = aws_db_instance.idea_box_rds.endpoint
}

resource "aws_ssm_parameter" "rds_dbClusterIdentifier" {
  name = "/idea-box/rds-dbClusterIdentifier"
  type = "String"
  value = aws_db_instance.idea_box_rds.identifier
}

data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = aws_db_instance.idea_box_rds.master_user_secret[0].secret_arn
}

resource "aws_ssm_parameter" "rds_password" {
  name = "/idea-box/rds-password"
  type = "SecureString"
  value = jsondecode(data.aws_secretsmanager_secret_version.rds_password.secret_string)["password"]
}