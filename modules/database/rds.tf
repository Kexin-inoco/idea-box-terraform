resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow access to RDS from Elastic Beanstalk EC2"
  vpc_id      = "vpc-0241f7fffff83ad0d"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "idea_box_rds" {
  allocated_storage           = var.allocated_storage
  engine                      = var.db_engine
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  manage_master_user_password = var.manage_master_pasword
  db_name                = "postgres"
  username                    = var.username
  apply_immediately           = true
  skip_final_snapshot = true
}