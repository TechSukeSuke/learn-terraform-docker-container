##########################
# vpc
##########################
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${local.app_name}-vpc"
  }
}

##########################
# internet gateway
##########################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.app_name}-igw"
  }
}

##########################
# subnet(public)
##########################
resource "aws_subnet" "public-1a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "${local.app_name}-public-1a"
  }
}

resource "aws_subnet" "public-1b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "${local.app_name}-public-1b"
  }
}

##########################
# subnet(private)
##########################
resource "aws_subnet" "private-1a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"
  tags = {
    Name = "${local.app_name}-private-1a"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.20.0/24"
  tags = {
    Name = "${local.app_name}-private-1b"
  }
}


##########################
# Elastic IP for nat
##########################
resource "aws_eip" "nat-1a" {
  vpc = true
  tags = {
    Name = "${local.app_name}-eip-for-natgw-1a"
  }
}

##########################
# NAT Gateway
##########################
resource "aws_nat_gateway" "nat-1a" {
  allocation_id = aws_eip.nat-1a.id
  subnet_id = aws_subnet.public-1a.id
  tags = {
    Name = "${local.app_name}-natgw-1a"
  }
}

##########################
# Route Table for public
##########################
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "${local.app_name}-public-rtb"
    }
}

resource "aws_route_table_association" "public-1a-to-igw" {
    subnet_id = aws_subnet.public-1a.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1b-to-igw" {
    subnet_id = aws_subnet.public-1b.id
    route_table_id = aws_route_table.public.id
}

##########################
# Route Table for private
##########################
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-1a.id
    }
    tags = {
        Name = "${local.app_name}-private-rtb"
    }
}

resource "aws_route_table_association" "private-1a-to-natgw" {
    subnet_id = aws_subnet.private-1a.id
    route_table_id = aws_route_table.private.id
}
