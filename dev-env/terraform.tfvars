#VPC
vpc_cidr_range = "10.0.0.0/16"
public_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_cidr = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
data_cidr = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]

#RDS variable values
multi_az = true
db_name = "devenv"
username = "xyzcloud"
password = "xyzcloud"
instance_class = "db.t3.micro"
allocated_storage = 10
engine = "mysql"
engine_version = "5.7"
port = "3306"
parameter_group_name = "default.mysql5.7"
deletion_protection = true