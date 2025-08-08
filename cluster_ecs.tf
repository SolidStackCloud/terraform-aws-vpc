resource "aws_ecs_cluster" "main" {
  count = var.habilitar_ecs_cluster ? 1 : 0
  name  = "${var.project_name}-cluster"
  setting {
    name = "containerInsights"
    value = "enhanced"
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main[0].name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}