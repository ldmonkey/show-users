resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-all-users-flask-webapp"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = var.subnet_count
  cidr_block        = "10.0.${var.subnet_count * (var.infrastructure_version - 1) + count.index + 1}.0/24"
  vpc_id            = aws_vpc.this.id
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  # availability_zone = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "all-users-flask-webapp-tf-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = var.subnet_count
  cidr_block        = "10.0.${var.subnet_count * (var.infrastructure_version - 1) + count.index + 1 + var.subnet_count}.0/24"
  vpc_id            = aws_vpc.this.id
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "all-users-flask-webapp-tf-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "igw-all-users-flask-webapp"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.rt_wide_route
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "all-users-flask-webapp-rt-public"
  }
}

resource "aws_default_route_table" "rt_private_default" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = {
    Name = "all-users-flask-webapp-rt-private-default"
  }
}

resource "aws_route_table_association" "public-rt-association" {
  count          = var.subnet_count
  route_table_id = aws_route_table.rt_public.id
  subnet_id      = aws_subnet.public_subnets.*.id[count.index]
}

resource "aws_route_table_association" "private-rt-association" {
  count          = var.subnet_count
  route_table_id = aws_route_table.rt_public.id
  subnet_id      = aws_subnet.private_subnets.*.id[count.index]
}
