resource "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/vpc-id"
  type = "String"
  value = aws_vpc.main.id

  depends_on = [ aws_vpc.main ]

  tags = {
    Name = "${var.project_name}-parameter-store"
  }
}

resource "aws_ssm_parameter" "public_subnets" {
  name = "/${var.project_name}/public-subnet-ids"
  type = "StringList"
  value = join(",", aws_subnet.public[*].id)

  depends_on = [ aws_subnet.public ]

  tags = {
    Name = "${var.project_name}-parameter-store"
  }
}


resource "aws_ssm_parameter" "private_subnets" {
  name = "/${var.project_name}/private-subnet-ids"
  type = "StringList"
  value = join(",", aws_subnet.private[*].id)

  depends_on = [ aws_subnet.private ]

  tags = {
    Name = "${var.project_name}-parameter-store"
  }
}

resource "aws_ssm_parameter" "pods_subnets" {
  name = "/${var.project_name}/pods-subnet-ids"
  type = "StringList"
  value = join(",", aws_subnet.pods[*].id)

  depends_on = [ aws_subnet.pods ]

  tags = {
    Name = "${var.project_name}-parameter-store"
  }
}