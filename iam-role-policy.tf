# Role for EC2 Instance
resource "aws_iam_role" "role-for-ec2" {
  name               = var.role-name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = var.role-name
    env  = var.env
  }
}

# Policy for EC2 Instance to access S3 bucket and SSMInstanceCore Access

resource "aws_iam_role_policy" "role-policy-for-ec2" {
  name = var.policy-name
  role = aws_iam_role.role-for-ec2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ssm:UpdateInstanceInformation"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.s3.arn}/*",
          "${aws_instance.application-instance.arn}/*"
        ]
      },
    ]
  })
}