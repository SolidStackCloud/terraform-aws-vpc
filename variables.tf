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
  default     = ""
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

variable "internal_alb" {
  description = "Variável utilizada para especificar se o LoadBalancer será do tipo internal"
  type        = bool
  default     = false
}

variable "alb_access_logs" {
  description = "Variável utilizar para habilitar os logs de acesso ao LoadBalancer"
  type        = bool
  default     = false
}

variable "loadbalancer_ssl_policy" {
  description = "Variável utilizada para especificar o tipo de política SSL utilizada pelo Listiner 443"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
}

variable "certificado_listiner_443" {
  description = "ARN do certificado que será utilizado pelo listiner 443 do LoadBalancer"
  type        = string
}

variable "habilitar_loadbalancer" {
  description = "Variável utilizada para especificar se o LoadBalancer será criado ou não"
  type        = bool
  default     = true
}

variable "habilitar_ecs_cluster" {
  description = "Variável utilizada para especificar se o Cluster ECS será criado ou não"
  type        = bool
  default     = true
}