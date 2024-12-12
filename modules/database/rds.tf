resource "aws_db_instance" "idea_box_rds" {
  allocated_storage           = var.allocated_storage
  engine                      = var.db_engine
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  manage_master_user_password = var.manage_master_pasword
  username                    = var.username
  apply_immediately           = true
  skip_final_snapshot = true
}