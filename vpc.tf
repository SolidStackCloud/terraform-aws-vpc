resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "main" {
  count      = var.create_additional_cidr ? 1 : 0
  vpc_id     = aws_vpc.main.id
  cidr_block = var.additional_cidr

  depends_on = [aws_vpc.main]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"
  tags = {
    Name = "${var.project_name}-s3-endpoint"
  }
}