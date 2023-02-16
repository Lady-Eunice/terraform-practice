# MY VPC
resource "aws_vpc" "E-VPC" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "E-VPC"
  }
}

resource "aws_subnet" "pub-sub-1" {
  vpc_id     = aws_vpc.E-VPC.id
  cidr_block = var.pub-sub-1-cidr_block

  tags = {
    Name = "pub-sub-1"
  }
}

resource "aws_subnet" "prvt-sub-2" {
  vpc_id     = aws_vpc.E-VPC.id
  cidr_block = var.prvt-sub-2-cidr_block

  tags = {
    Name = "prvt-sub-2"
  }
}

resource "aws_route_table" "pub-rt-table" {
  vpc_id = aws_vpc.E-VPC.id
  tags = {
    Name = "pub-rt-table"
  }
}

resource "aws_route_table" "prvt-rt-table" {
  vpc_id = aws_vpc.E-VPC.id
  tags = {
    Name = "prvt-rt-table"
  }
}

resource "aws_route_table_association" "pub-rt-1-ass" {
  subnet_id      = aws_subnet.pub-sub-1.id
  route_table_id = aws_route_table.pub-rt-table.id
}

resource "aws_route_table_association" "prvt-rt-1-ass" {
  subnet_id      = aws_subnet.prvt-sub-2.id
  route_table_id = aws_route_table.prvt-rt-table.id
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.E-VPC.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route" "pub-IGW-route" {
  route_table_id            = aws_route_table.pub-rt-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.IGW.id
}

resource "aws_eip" "EIP" {
  vpc      = true
}

# Create NAT Gateway
# create aws nat gateway
resource "aws_nat_gateway" "NAT-GW" {
  allocation_id = aws_eip.EIP.id 
  subnet_id     = aws_subnet.pub-sub-1.id

  tags = {
    Name = "NAT-GW"
  }
}

# Create Security Groups
# create aws security groups
resource "aws_security_group" "E-sec-group" {
  name        = "E-sec-group"
  description = "var.E-sec-group-aws_security_group"
  vpc_id      = aws_vpc.E-VPC.id

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.E-VPC.cidr_block]
  }

  ingress {
    description      = "HTTP access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.E-VPC.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.E-VPC.cidr_block]
  }

  tags = {
    Name = "E-sec-group"
  }
}

# Create an EC2 
# create aws ec2 instance
resource "aws_instance" "E-VPC" {
  subnet_id      = aws_subnet.pub-sub-1.id
  ami           = var.E-VPC-aws_instance
  instance_type = "t2.micro"
  tenancy       ="default"

  tags = {
    Name = "E-VPC"
  }
}


resource "aws_network_interface" "E-network-interface" {
  subnet_id   = aws_subnet.pub-sub-1.id

  tags = {
    Name = "E-network-interface"
  }
}



