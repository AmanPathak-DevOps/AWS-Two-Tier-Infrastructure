resource "aws_iam_instance_profile" "instance-profile" {
  name = var.instance-profile-name
  role = aws_iam_role.role-for-ec2.name
}