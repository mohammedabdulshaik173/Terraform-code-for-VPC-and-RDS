#Get the availability zones
data "aws_availability_zones" "availability-zones" {
  state = "available"
}

#create the VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_range
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "vpc"
  }
}
#create the public subnet
resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.availability-zones.names)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.public_cidr,count.index)
  map_public_ip_on_launch = "true"
  availability_zone = element(data.aws_availability_zones.availability-zones.names,count.index)

  tags = {
    Name = "public-subnet-${count.index+1}"
  }
}

#create the subnets
#create the private subnet
resource "aws_subnet" "private" {
  count = length(data.aws_availability_zones.availability-zones.names)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.private_cidr,count.index)
  availability_zone = element(data.aws_availability_zones.availability-zones.names,count.index)

  tags = {
    Name = "private-subnet-${count.index+1}"
  }
}

#create the data subnet
resource "aws_subnet" "data" {
  count = length(data.aws_availability_zones.availability-zones.names)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.data_cidr,count.index)
  availability_zone = element(data.aws_availability_zones.availability-zones.names,count.index)

  tags = {
    Name = "data-subnet-${count.index+1}"
  }
}

#create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW"
  }
}

#create Elastic IP
resource "aws_eip" "eip" {
  vpc      = true
}

#create NAT-GW
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "NAT-GW"
  }
  depends_on = [aws_eip.eip]
}
#create Route tables
#create public route
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route"
  }
}
#create private route
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/24"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "private_route"
  }
}

#create subnet association
#public subnet association
resource "aws_route_table_association" "public_subnet_association" {
  count = length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public_route.id
}

#private subnet association
resource "aws_route_table_association" "private_subnet_association" {
  count = length(aws_subnet.private[*].id)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private_route.id
}

#data subnet association
resource "aws_route_table_association" "data_subnet_association" {
  count = length(aws_subnet.data[*].id)
  subnet_id      = element(aws_subnet.data[*].id,count.index)
  route_table_id = aws_route_table.private_route.id
}

