# Creating Instance Profile to attach with Application Server
resource "aws_iam_instance_profile" "instance-profile" {
  name = var.instance_profile_name
  role = aws_iam_role.role-for-ec2.name
}