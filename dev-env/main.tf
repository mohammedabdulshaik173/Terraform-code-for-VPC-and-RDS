module "vpc" {
    source = "../modules/vpc"
    vpc_cidr_range = var.vpc_cidr_range
    public_cidr = var.public_cidr
    private_cidr = var.private_cidr
    data_cidr = var.data_cidr
    
}

module "rds" {
  source = "../modules/rds"
multi_az = var.multi_az
db_name = var.db_name
username = var.username
password = var.password
instance_class = var.instance_class
allocated_storage = var.allocated_storage
engine = var.engine
engine_version = var.engine_version
port = var.port
parameter_group_name = var.parameter_group_name
deletion_protection = var.deletion_protection
}