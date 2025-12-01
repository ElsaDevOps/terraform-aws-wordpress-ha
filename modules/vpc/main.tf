terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}




# Creating Custom VPC

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr_blockvpc
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
  }
}


# # Create Public and Private Subnets

# Public subnet web tier

resource "aws_subnet" "public_subnet" {
  for_each                = { for i, availability_zone in var.availability_zones : availability_zone => var.cidr_public_subnet_web[i] }
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet web"
  }
}




# private subnet app tier

resource "aws_subnet" "private_subnet_app" {
  for_each                = { for i, availability_zone in var.availability_zones : availability_zone => var.cidr_private_subnet_app[i] }
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = "Private subnet app"
  }
}



#private subnet data tier

resource "aws_subnet" "private_subnet_data" {
  for_each                = { for i, availability_zone in var.availability_zones : availability_zone => var.cidr_private_subnet_data[i] }
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = "Private subnet data"
  }
}


# # Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}


# # NAT Gateway

resource "aws_eip" "nat" {
  for_each = aws_subnet.public_subnet
  domain   = "vpc"

  tags = {
    name = "eip-nat-${each.key}"
  }
}



resource "aws_nat_gateway" "nat_gateway" {
  for_each      = aws_subnet.public_subnet
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "nat-$[each.key]"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Public route table"
  }
}

resource "aws_route" "public_default" {
  for_each               = aws_subnet.public_subnet
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

}

# private app

resource "aws_route_table" "private_route_table" {
  for_each = aws_subnet.private_subnet_app
  vpc_id   = aws_vpc.my_vpc.id
  tags = {
    Name = "Private route table ${each.key}"
  }
}

resource "aws_route" "private_default" {
  for_each               = aws_subnet.private_subnet_app
  route_table_id         = aws_route_table.private_route_table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[each.key].id

}


# private data
resource "aws_route_table" "private_data" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Private route table data"
  }
}

# # Route table associations to subnets

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_app" {
  for_each       = aws_subnet.private_subnet_app
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table[each.key].id
}

resource "aws_route_table_association" "private_data" {
  for_each       = aws_subnet.private_subnet_data
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_data.id
}
