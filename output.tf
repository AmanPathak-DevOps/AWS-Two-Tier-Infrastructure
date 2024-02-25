# Printing the AMI ID
output "ami-id" {
  value = data.aws_ami.ami.id
}