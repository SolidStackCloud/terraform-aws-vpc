# Construção das subnets 

data "aws_availability_zones" "main" {

}

resource "aws_subnet" "public" {
  count             = var.subnet_number
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.main.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.subnet_number
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}