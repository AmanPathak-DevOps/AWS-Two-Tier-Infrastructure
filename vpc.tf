resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = var.igw_name
    Environment = var.env
  }

}

resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.application-subnet-cidr-block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = var.subnet1-name
    Environment = var.env
  }

}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = var.public-subnet-rt-name
    Environment = var.env
  }

}

resource "aws_route_table_association" "rt1-association" {
  route_table_id = aws_route_table.rt1.id
  subnet_id      = aws_subnet.public-subnet1.id

}

resource "aws_subnet" "private-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db-subnet1-cidr-block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = var.subnet2-name
    Environment = var.env
  }

}

resource "aws_subnet" "private-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db-subnet2-cidr-block
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name        = var.subnet3-name
    Environment = var.env
  }
}