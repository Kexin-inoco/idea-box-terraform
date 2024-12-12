output "rds_secret_arn" {
  description = "The ARN of the Secret Manager srcret for the RDS instance"
  value       = aws_ssm_parameter.rds_recret_arn
  sensitive = true
}

output "rds_endpoint" {
  description = "The connection endpoint for RDS database"
  value = aws_ssm_parameter.rds_endpoint
  sensitive = true
}

output "rds_dbClusterIdentifier" {
  description = "The db identifier for RDS database"
  value = aws_ssm_parameter.rds_dbClusterIdentifier
  sensitive = true
}

output "rds_password" {
  description = "The db password for RDS database"
  value = aws_ssm_parameter.rds_password
  sensitive = true
}