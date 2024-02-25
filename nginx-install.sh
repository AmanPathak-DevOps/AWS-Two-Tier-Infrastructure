#! /bin/bash
apt update
apt install nginx -y
systemctl enable nginx
systemctl start nginx
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws --version
