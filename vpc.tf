resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "TerraformLabVPC"
  }
}
resource "aws_subnet" "subnets" {
  for_each                = var.subnet_cidrs
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value[0]
  map_public_ip_on_launch = each.value[1]
  availability_zone       = var.availability_zones[0]
  tags = {
    Name = each.key
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MainIGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}


resource "aws_eip" "nat_eip" {
  domain = "vpc"
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnets["public"].id
  tags = {
    Name = "NatGateway"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "assoc" {
  for_each       = var.subnet_cidrs
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = each.key == "public" ? aws_route_table.public.id : aws_route_table.private.id

}
