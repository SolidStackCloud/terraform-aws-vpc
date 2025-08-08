resource "aws_subnet" "pods" {
  count             = var.create_additional_cidr ? var.subnet_number : 0
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.main.names[count.index]
  cidr_block        = cidrsubnet(var.additional_cidr, 8, count.index + var.subnet_number)
  tags = {
    Name = "${var.project_name}-pods-subnet-${count.index + 1}"
  }

  depends_on = [aws_vpc_ipv4_cidr_block_association.main]
}

resource "aws_route_table_association" "pods" {
  count          = var.create_additional_cidr ? var.subnet_number : 0
  subnet_id      = aws_subnet.pods[count.index].id
  route_table_id = aws_route_table.private.id
}
