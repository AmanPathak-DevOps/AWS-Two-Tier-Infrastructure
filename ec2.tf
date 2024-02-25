resource "aws_instance" "application-instance" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_size
  subnet_id              = aws_subnet.public-subnet1.id
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.sg1.id]
  iam_instance_profile   = aws_iam_instance_profile.instance-profile.name

  root_block_device {
    volume_size = 100
    encrypted   = true
  }

  # We can configure using Ansible, but for the demo purpose we are installing nginx
  user_data = templatefile("./nginx-install.sh", {})

  tags = {
    Name = var.instance_name
  }
}

resource "aws_eip" "eip" {
  domain   = "vpc"
  instance = aws_instance.application-instance.id
}