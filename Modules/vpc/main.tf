resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.enviroment}-vpc"
    Environment = "${var.enviroment}"
  }
}

resource "aws_subnet" "app_subnet_one" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.subnet_cidr_blocks[0]
  map_public_ip_on_launch = var.private
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "${var.enviroment}-subnet-1a"
    Environment = "${var.enviroment}"
  }
}

resource "aws_subnet" "app_subnet_two" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.subnet_cidr_blocks[1]
  map_public_ip_on_launch = var.private
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "${var.enviroment}-subnet-1b"
    Environment = "${var.enviroment}"
  }
}

resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
  
  tags = {
    Name = "${var.enviroment}-igw"
    Environment = "${var.enviroment}"
  }
}

resource "aws_route_table" "app_rt" {
  vpc_id = aws_vpc.app_vpc.id
  
  tags = {
    Name = "${var.enviroment}-rt"
    Environment = "${var.enviroment}"
  } 
}

resource "aws_route" "app_route" {
  route_table_id = aws_route_table.app_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.app_igw.id
}

resource "aws_route_table_association" "app_rta_subnet_one" {
  subnet_id      = aws_subnet.app_subnet_one.id
  route_table_id = aws_route_table.app_rt.id
}

resource "aws_route_table_association" "app_rta_subnet_two" {
  subnet_id      = aws_subnet.app_subnet_two.id
  route_table_id = aws_route_table.app_rt.id
}

