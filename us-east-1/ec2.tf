# Find the latest Amazon Linux 2 AMI
data "aws_ssm_parameter" "amazon_linux_2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Create a security group named 'customer-securitygrp' with ingress rules
resource "aws_security_group" "customer_securitygrp" {
  vpc_id = aws_vpc.AWS_CUSTOMER_VPC.id
  name        = "customer-securitygrp"
  description = "customer-securitygrp"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SSH access from anywhere 
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # All TCP traffic from anywhere 
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # All ICMP traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

# Launch the EC2 instance
resource "aws_instance" "customer_linux" {
  ami           = data.aws_ssm_parameter.amazon_linux_2.value
  instance_type = "t2.micro"
  key_name = "keypair"
  

  tags = {
    Name = "Customer-Linux-Instance"
  }

  vpc_security_group_ids = [aws_security_group.customer_securitygrp.id]

  subnet_id = aws_subnet.AWS_CUSTOMER_SUBNET.id # Use the first subnet in the VPC

  # Enable auto-assign public IP
  associate_public_ip_address = true
}

# Output the public IP address of the instance
output "public_ip" {
  value = aws_instance.customer_linux.public_ip
}
