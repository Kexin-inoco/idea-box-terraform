variable "db_engine" {
  description = "The RDS database engine"
  default     = "postgres"
}

variable "db_engine_version" {
  description = "The version of the RDS database engine"
  default     = "16.3"
}

variable "db_instance_class" {
  description = "The instance class for RDS"
  default     = "db.t3.small"
}

variable "allocated_storage" {
  description = "The allocated storage size for RDS in GB"
  default     = 10
}

variable "availbility_zon" {
  description = "The availbility zone for RDS instance"
  default     = ["eu-west-3a", "eu-west-3b"]
}

variable "manage_master_pasword" {
  description = "If enable Secret Manager to manage the master password"
  default     = true
}

variable "username" {
  description = "The master username for the RDS database"
  default     = "devuser"
}