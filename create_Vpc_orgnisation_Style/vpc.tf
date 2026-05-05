# Create a VPC
resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = merge(var.tags , {
        "Name" = "${var.environment}-vpc"
    })
  
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = merge(var.tags , {
        "Name" = "${var.environment}-igw"
})
}
# Create public subnets
resource "aws_subnet" "public-rt" {

  for_each = {for idx, az in local.azs : az => local.public_subnet[idx] }
  vpc_id = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true

  tags = merge(var.tags , {
    "Name" = "${var.environment}-public-subnet-${count.index + 1}"
})
}

#private subnets
resource "aws_subnet" "private-rt" {

  for_each = {for idx, az in local.azs : az => local.private_subnet[idx] }
  vpc_id = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = each.key

  tags = merge(var.tags , {
    "Name" = "${var.environment}-private-subnet-${count.index + 1}"
})
}

#elastic IP for NAT Gateway
resource "aws_eip" "nat-eip" {
  tags = merge(var.tags , {
    "Name" = "${var.environment}-nat-eip"
})
}

# Create a NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id = values(aws_subnet.public-rt)[0].id
  tags = merge(var.tags , {
    "Name" = "${var.environment}-nat-gw"
})
  depends_on = [ aws_internet_gateway.igw ]
}

# Create a route table for public subnets
resource "aws_route_table" "public-rtable" {
  vpc_id = aws_vpc.main.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags , {
    "Name" = "${var.environment}-public-rt"
})
}
#associate public subnets with route table
resource "aws_route_table_association" "public-rt-ass" {
  for_each = aws_subnet.public-rt
  subnet_id = each.value.id
  route_table_id = aws_route_table.public-rtable.id
}   

# Create private subnet route table
resource "aws_route_table" "private-rtable" {   
  vpc_id = aws_vpc.main.id
  route = {
    cidr_block = "0.0.,0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = merge(var.tags , {
    "Name" = "${var.environment}-private-rt"
})
}

#associate private subnets with route table
resource "aws_route_table_association" "private-rt-ass" {
  for_each = aws_subnet.private-rt
  subnet_id = each.value.id
  route_table_id = aws_route_table.private-rtable.id
}