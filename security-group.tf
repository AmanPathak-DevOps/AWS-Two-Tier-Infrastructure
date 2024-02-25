resource "aws_security_group" "sg1" {
  vpc_id      = aws_vpc.vpc.id
  description = "Allowing SSH, HTTP and HTTPS"


  ingress {
    description      = "Allowing HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allowing HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Allowing SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.150.138.152/32"]
  }

  egress {
    description = "Giving full Access of Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg-name
  }

}

# Creating Security Group for RDS Instances Tier With  only access to App-Tier Public IP
resource "aws_security_group" "db-sg" {
  vpc_id      = aws_vpc.vpc.id
  description = "Protocol Type MySQL/Aurora"

  ingress {
    description     = "Allowing MySQL to Application Server Only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sg1.id]
  }

  egress {
    description      = "Giving full Access of Internet"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.db-sg-name
  }

}