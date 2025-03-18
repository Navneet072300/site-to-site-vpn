resource "aws_vpc" "AWS_CUSTOMER_VPC" {
  cidr_block       = "10.2.0.0/16"
  

  tags = {
    Name = "AWS_CUSTOMER_VPC"
    
  }
}

resource "aws_subnet" "AWS_CUSTOMER_SUBNET" {
  vpc_id     = aws_vpc.AWS_CUSTOMER_VPC.id 
  cidr_block = "10.2.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "AWS_CUSTOMER_SUBNET"
    
    
  }
}

resource "aws_internet_gateway" "AWS_CUSTOMER_IGW" {
  vpc_id = aws_vpc.AWS_CUSTOMER_VPC.id

  tags = {
    Name = "AWS_CUSTOMER_IGW"
    
  }
}

resource "aws_route_table" "AWS_CUSTOMER_ROUTE" {
  vpc_id = aws_vpc.AWS_CUSTOMER_VPC.id  # Replace with the actual VPC ID

  tags = {
    Name = "AWS_CUSTOMER_ROUTE"
    
  }
}

resource "aws_route" "AWS_CUSTOMER_ROUTE" {
  route_table_id = aws_route_table.AWS_CUSTOMER_ROUTE.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id     = aws_internet_gateway.AWS_CUSTOMER_IGW.id # Replace with actual internet gateway ID

  depends_on = [aws_vpc.AWS_CUSTOMER_VPC]  # Ensure VPC is created before route
  
}