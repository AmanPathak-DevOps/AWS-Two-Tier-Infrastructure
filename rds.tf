# Creating DB subnet group with two Private Subnets for RDS Instances
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = [aws_subnet.private-subnet1.id, aws_subnet.private-subnet2.id]

  tags = {
    Name        = var.subnet_group_name
    Environment = var.env
  }
}

# Creating RDS Instance with automated backup
resource "aws_db_instance" "db-instance" {
  allocated_storage                   = var.allocated_storage
  db_name                             = var.db_name
  db_subnet_group_name                = aws_db_subnet_group.db_subnet_group.id
  engine                              = "mysql"
  engine_version                      = "5.7"
  vpc_security_group_ids              = [aws_security_group.db-sg.id]
  instance_class                      = var.db_instance_size
  username                            = var.rds_username
  password                            = var.rds_pwd
  parameter_group_name                = "default.mysql5.7"
  skip_final_snapshot                 = true
  final_snapshot_identifier           = "database-1-snapshot"
  storage_encrypted                   = var.storage_encrypted
  deletion_protection                 = var.deletion_protection
  publicly_accessible                 = var.publicly_accessible
  iam_database_authentication_enabled = true
  multi_az                            = var.multi_az

  maintenance_window       = "Mon:00:00-Mon:03:00"
  backup_window            = "03:00-06:00"
  backup_retention_period  = var.retention_period
  delete_automated_backups = false
  blue_green_update {
    enabled = false
  }

  tags = {
    Name        = var.rds_name
    Environment = var.env
  }
}