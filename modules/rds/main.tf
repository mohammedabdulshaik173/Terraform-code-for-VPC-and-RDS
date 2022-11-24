#create the subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "rd-subnet-group-1"
  subnet_ids = data.aws_subnet_ids.available_db_subnet.ids

  tags = {
    Name = "rds-subnet-group-1"
  }
}

#create the rds
resource "aws_db_instance" "rds_instance" {
  multi_az = var.multi_az
  db_name = var.db_name
  username             = var.username
  password             = var.password
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  port = var.port
  parameter_group_name = var.parameter_group_name
  deletion_protection = var.deletion_protection
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
}

#datasource
data "aws_vpc" "vpc_available" {
  filter {
    name   = "tag:Name"
    values = ["vpc"]
  }
}
data "aws_subnet_ids" "available_db_subnet" {
  vpc_id = data.aws_vpc.vpc_available.id
  filter {
    name   = "tag:Name"
    values = ["data-sub*"]
  }
}

