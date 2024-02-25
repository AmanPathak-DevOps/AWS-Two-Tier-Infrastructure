# Creating DB subnet group for RDS Instances
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.subnet-group-name
  subnet_ids = [aws_subnet.private-subnet1.id, aws_subnet.private-subnet2.id]

  tags = {
    Name        = var.subnet-group-name
    Environment = var.env
  }
}

resource "aws_db_instance" "db-instance" {
  allocated_storage                   = 20
  db_name                             = var.db-name
  db_subnet_group_name                = aws_db_subnet_group.db_subnet_group.id
  engine                              = "mysql"
  engine_version                      = "5.7"
  vpc_security_group_ids              = [aws_security_group.db-sg.id]
  instance_class                      = var.db-instance-size
  username                            = var.rds-username
  password                            = var.rds-pwd
  parameter_group_name                = "default.mysql5.7"
  skip_final_snapshot                 = true
  final_snapshot_identifier           = "database-1-snapshot"
  storage_encrypted                   = true
  deletion_protection                 = false
  publicly_accessible                 = false
  iam_database_authentication_enabled = true
  multi_az                            = true
  #   iops = 100

  maintenance_window       = "Mon:00:00-Mon:03:00"
  backup_window            = "03:00-06:00"
  backup_retention_period  = 7
  delete_automated_backups = false
  blue_green_update {
    enabled = false
  }

  tags = {
    Name        = var.rds-name
    Environment = var.env
  }
}