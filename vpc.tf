# Creating VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name        = var.vpc_name
    Environment = var.env
  }
}

# Creating Internet Gateway and attaching with VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = var.igw_name
    Environment = var.env
  }

}

# Creating Public Subnet 
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.application_subnet_cidr_block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = var.subnet1_name
    Environment = var.env
  }
}

# Creating Public Route table and add internet gateway in route
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = var.public_subnet_rt_name
    Environment = var.env
  }

}

# Attaching Public Route table with Public Subnet
resource "aws_route_table_association" "rt1-association" {
  route_table_id = aws_route_table.rt1.id
  subnet_id      = aws_subnet.public-subnet1.id

}

# Creating Private Subnet1
resource "aws_subnet" "private-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db_subnet1_cidr_block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = var.subnet2_name
    Environment = var.env
  }

}

# Creating Private Subnet2
resource "aws_subnet" "private-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db_subnet2_cidr_block
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name        = var.subnet3_name
    Environment = var.env
  }
}