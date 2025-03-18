resource "aws_vpc" "AWS_SITE_VPC" {
  cidr_block       = "10.1.0.0/16"
  

  tags = {
    Name = "AWS_SITE_VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.AWS_SITE_VPC.id 
  cidr_block = "10.1.0.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "AWS_SITE_SUBNET"
  }
}

resource "aws_internet_gateway" "AWS_SITE_IGW" {
  vpc_id = aws_vpc.AWS_SITE_VPC.id

  tags = {
    Name = "AWS_SITE_IGW"
  }
}

resource "aws_route_table" "AWS_SITE_ROUTE" {
  vpc_id = aws_vpc.AWS_SITE_VPC.id  # Replace with the actual VPC ID

  tags = {
    Name = "AWS_SITE_ROUTE"
  }
}

resource "aws_route" "internet_route" {
  route_table_id = aws_route_table.AWS_SITE_ROUTE.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id     = aws_internet_gateway.AWS_SITE_IGW.id # Replace with actual internet gateway ID

  depends_on = [aws_vpc.AWS_SITE_VPC]  # Ensure VPC is created before route
}