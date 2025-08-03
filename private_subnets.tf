resource "aws_subnet" "private" {
  count = var.subnet_number
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.main.names[count.index]
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, count.index + var.subnet_number)
  tags = {
    Name = "${var.project_name}-private-subnet-${count.index+1}"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
    depends_on = [aws_internet_gateway.main, aws_subnet.public]
}

resource "aws_eip" "nat" {
    domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_route_table_association" "private" {
  count = var.subnet_number
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
