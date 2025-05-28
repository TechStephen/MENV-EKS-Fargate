resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.enviroment}-vpc"
    Environment = "${var.enviroment}"
  }
}

# Private Subnet for Application in AZ 1a
resource "aws_subnet" "app_subnet_one" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.subnet_cidr_blocks[0]
  map_public_ip_on_launch = false
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "${var.enviroment}-subnet-1a"
    Environment = "${var.enviroment}"
    "kubernetes.io/cluster/${var.enviroment}-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Private Subnet for Application in AZ 1b
resource "aws_subnet" "app_subnet_two" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.subnet_cidr_blocks[1]
  map_public_ip_on_launch = false
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "${var.enviroment}-subnet-1b"
    Environment = "${var.enviroment}"
    "kubernetes.io/cluster/${var.enviroment}-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Public Subnet for NAT Gateway in AZ 1a
resource "aws_subnet" "nat_subnet_one" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.subnet_cidr_blocks[2]
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "${var.enviroment}-nat-subnet-1a"
    Environment = "${var.enviroment}"
    "kubernetes.io/cluster/${var.enviroment}-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

# Public Subnet for NAT Gateway in AZ 1b
resource "aws_subnet" "nat_subnet_two" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.subnet_cidr_blocks[3]
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "${var.enviroment}-nat-subnet-1b"
    Environment = "${var.enviroment}"
    "kubernetes.io/cluster/${var.enviroment}-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_eip" "nat_eip_one" {
  tags = {
    Name = "${var.enviroment}-nat-eip-1a"
    Environment = "${var.enviroment}"
  }
}

resource "aws_eip" "nat_eip_two" {
    tags = {
    Name = "${var.enviroment}-nat-eip-1b"
    Environment = "${var.enviroment}"
  }
}

resource "aws_nat_gateway" "app_nat_gateway_one" {
  allocation_id = aws_eip.nat_eip_one.id
  subnet_id     = aws_subnet.nat_subnet_one.id
  
  tags = {
    Name = "${var.enviroment}-nat-gateway-1a"
    Environment = "${var.enviroment}"
  }
}

resource "aws_nat_gateway" "app_nat_gateway_two" {
  allocation_id = aws_eip.nat_eip_two.id
  subnet_id     = aws_subnet.nat_subnet_two.id
  
  tags = {
    Name = "${var.enviroment}-nat-gateway-1b"
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

# Route Table for Public Subnet NAT Gateways
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.enviroment}-public-rt"
  }
}
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_igw.id
}
resource "aws_route_table_association" "public_rta_one" {
  subnet_id      = aws_subnet.nat_subnet_one.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rta_two" {
  subnet_id      = aws_subnet.nat_subnet_two.id
  route_table_id = aws_route_table.public_rt.id
}

# --- Route Table for Private Subnet 1a --- 
resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.enviroment}-private-rt-1a"
  }
}

resource "aws_route" "private_route_1a" {
  route_table_id         = aws_route_table.private_rt_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.app_nat_gateway_one.id
}

resource "aws_route_table_association" "private_rta_1a" {
  subnet_id      = aws_subnet.app_subnet_one.id
  route_table_id = aws_route_table.private_rt_1a.id
}

# ---  Route Table for Private Subnet 1b ---
resource "aws_route_table" "private_rt_1b" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.enviroment}-private-rt-1b"
  }
}

resource "aws_route" "private_route_1b" {
  route_table_id         = aws_route_table.private_rt_1b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.app_nat_gateway_two.id
}

resource "aws_route_table_association" "private_rta_1b" {
  subnet_id      = aws_subnet.app_subnet_two.id
  route_table_id = aws_route_table.private_rt_1b.id
}


