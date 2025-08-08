resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/vpc-id"
  type  = "String"
  value = aws_vpc.main.id

  depends_on = [aws_vpc.main]

  tags = {
    Name = "${var.project_name}-parameter-store"
  }
}

resource "aws_ssm_parameter" "public_subnets" {
  name  = "/${var.project_name}/public-subnet-ids"
  type  = "StringList"
  value = join(",", aws_subnet.public[*].id)

  depends_on = [aws_subnet.public]

  tags = {
    Name = "${var.project_name}-parameter-store"
  }
}


resource "aws_ssm_parameter" "private_subnets" {
  name  = "/${var.project_name}/private-subnet-ids"
  type  = "StringList"
  value = join(",", aws_subnet.private[*].id)

  depends_on = [aws_subnet.private]

  tags = {
    Name = "${var.project_name}-parameter-store"
  }
}

resource "aws_ssm_parameter" "pods_subnets" {
  name  = "/${var.project_name}/pods-subnet-ids"
  type  = "StringList"
  value = join(",", aws_subnet.pods[*].id)

  depends_on = [aws_subnet.pods]

  tags = {
    Name = "${var.project_name}-parameter-store"
  }
}

resource "aws_ssm_parameter" "loadbalancer_listiner" {
  count = var.habilitar_loadbalancer ? 1 : 0
  name  = "/${var.project_name}/loadbalance"
  type  = "String"
  value = aws_alb_listener.listiner_443[0].arn

  depends_on = [aws_alb_listener.listiner_443]

  tags = {
    Name = "${var.project_name}-parameter-store"
  }
}

resource "aws_ssm_parameter" "vpc_cidr" {
  name  = "/${var.project_name}/vpc_cidr"
  type  = "String"
  value = aws_vpc.main.cidr_block

  depends_on = [aws_vpc.main]

  tags = {
    Name = "${var.project_name}-parameter-store"
  }
}

resource "aws_ssm_parameter" "cluster_name" {
  name  = "/${var.project_name}/cluster-name"
  type  = "String"
  value = aws_ecs_cluster.main[0].id

  depends_on = [aws_vpc.main]

  tags = {
    Name = "${var.project_name}-parameter-store"
  }
}