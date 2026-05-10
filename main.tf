resource "aws_vpc" "terraform_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "clc15-tf-vpc" 
           CC ="1234567"
           Owner ="Devops"
  }
}

resource "aws_subnet" "subnet_public_1a" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "public-tf-subnet-1a" }
}

resource "aws_subnet" "subnet_public_1b" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "public-tf-subnet-1b" }
}

resource "aws_subnet" "subnet_private_1a" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "private-tf-subnet-1a" }
}

resource "aws_subnet" "subnet_private_1b" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.200.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "private-tf-subnet-1b" }
}

resource "aws_internet_gateway" "tf_gw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = { Name = "tf-vpc-igw" }
}

resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_gw.id
  }
  tags = { Name = "tf-public-rt" }
}

resource "aws_route_table_association" "public_1a_association" {
  subnet_id      = aws_subnet.subnet_public_1a.id
  route_table_id = aws_route_table.tf_public_rt.id
}

resource "aws_route_table_association" "public_1b_association" {
  subnet_id      = aws_subnet.subnet_public_1b.id
  route_table_id = aws_route_table.tf_public_rt.id
}

resource "aws_route_table" "tf_private_rt_1a" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags   = { Name = "tf-private-rt-1a" }
}

resource "aws_route_table_association" "private_1a_association" {
  subnet_id      = aws_subnet.subnet_private_1a.id
  route_table_id = aws_route_table.tf_private_rt_1a.id
}

resource "aws_route_table" "tf_private_rt_1b" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags   = { Name = "tf-private-rt-1b" }
}

resource "aws_route_table_association" "private_1b_association" {
  subnet_id      = aws_subnet.subnet_private_1b.id
  route_table_id = aws_route_table.tf_private_rt_1b.id
}

output "vpc_id" {
  value = aws_vpc.terraform_vpc.id
}

output "public_subnets" {
  value = [aws_subnet.subnet_public_1a.id, aws_subnet.subnet_public_1b.id]
}

output "private_subnets" {
  value = [aws_subnet.subnet_private_1a.id, aws_subnet.subnet_private_1b.id]
}
