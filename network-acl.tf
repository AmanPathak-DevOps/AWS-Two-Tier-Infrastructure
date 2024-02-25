# Creating NACL and allowing 80, 443 and 22 port for specific IPs and denying other IPs
resource "aws_network_acl" "network-acl-pub-sub" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    rule_no    = 100
    action     = "allow"
  }

  ingress {
    from_port  = 443
    to_port    = 443
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    rule_no    = 200
    action     = "allow"
  }

  ingress {
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_block = "103.150.138.152/32"
    rule_no    = 300
    action     = "allow"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    rule_no    = 400
    action     = "deny"
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    rule_no    = 100
    action     = "allow"
  }


  tags = {
    Environment = var.env
  }
}

# Attaching the NACL with Public Subnet
resource "aws_network_acl_association" "nacl-association-public" {
  subnet_id      = aws_subnet.public-subnet1.id
  network_acl_id = aws_network_acl.network-acl-pub-sub.id
}

# Creating NACL and allowing 3306 port for Application Server Only and denying other IPs
resource "aws_network_acl" "network-acl-pri-sub" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port  = 3306
    to_port    = 3306
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    rule_no    = 100
    action     = "allow"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    rule_no    = 200
    action     = "deny"
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    rule_no    = 100
    action     = "allow"
  }

  tags = {
    Environment = var.env
  }
}

# Attaching the NACL with Private Subnet1
resource "aws_network_acl_association" "nacl-association-private" {
  subnet_id      = aws_subnet.private-subnet1.id
  network_acl_id = aws_network_acl.network-acl-pri-sub.id
}

# Attaching the NACL with Private Subnet2
resource "aws_network_acl_association" "nacl-association-private2" {
  network_acl_id = aws_network_acl.network-acl-pri-sub.id
  subnet_id      = aws_subnet.private-subnet2.id
}