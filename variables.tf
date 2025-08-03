variable "project_name" {
  description = "Nome do projeto. Esse nome será utiliza como variável para outros recursos na tag Name"
  type        = string
}

variable "region" {
  description = "Região onde serão provisionados os recursos na AWS"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR da VPC main. Será utilizado no calculo da função cidrsubnet para calculo dos CIDRs de forma dinâmica"
  type        = string
}

variable "additional_cidr" {
  description = "CIDR adicional para subnet de pods. Será utilizado no calculo da função cidrsubnet para calculo dos CIDRs de forma dinâmica"
  type        = string
  default = ""
}
variable "create_additional_cidr" {
  description = "Define se deve ser criado um CIDR adicional para pods"
  type        = bool
  default     = false
}
variable "subnet_number" {
  description = "Número de subnets por Zona de disponibilidade. Essa variável é utilizada para construir as Subnets de forma dinâmica"
  type        = number
}
