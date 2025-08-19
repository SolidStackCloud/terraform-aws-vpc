# Módulo VPC AWS

## Introdução

Este módulo Terraform provisiona um ambiente de Virtual Private Cloud (VPC) dinamicamente configurável na AWS. Ele cria uma VPC com sub-redes públicas e privadas, um gateway de internet, um gateway NAT e tabelas de roteamento.

Opcionalmente, o módulo pode criar e configurar recursos adicionais, como:

- Sub-redes dedicadas para Pods (ideal para clusters Kubernetes), associando um bloco CIDR secundário à VPC.
- Endpoints de VPC para serviços como o S3.
- Salvar as saídas principais no AWS Systems Manager Parameter Store para fácil integração com outras automações.

## Pré-requisitos

- Terraform `6.7.0` ou superior.
- Credenciais AWS configuradas com as permissões necessárias para criar os recursos descritos.

## Uso

Para utilizar este módulo, inclua-o em sua configuração Terraform e especifique as variáveis necessárias.

```hcl
module "vpc" {
  source  = "LucasCloudUniverse/vpc/aws"
  version = "1.0.0"

  # Variáveis obrigatórias
  project_name          = "meu-projeto-incrivel"
  region                = "us-east-1"
  vpc_cidr_block        = "10.0.0.0/16"
  subnet_number         = 2

  # Habilitando recursos opcionais
  create_additional_cidr = true
  additional_cidr       = "100.64.0.0/16"
}
```

## Recursos Opcionais

Este módulo utiliza variáveis booleanas para controlar a criação de recursos específicos, permitindo uma configuração flexível.

- **Sub-redes para Pods:** Defina `create_additional_cidr = true` e forneça um valor para `additional_cidr` para criar um conjunto de sub-redes adicionais, úteis para EKS ou outros cenários de contêineres.

## Parameter Store

O módulo armazena os IDs e ARNs dos principais recursos no AWS Systems Manager Parameter Store, facilitando a consulta por outras aplicações ou módulos. Os seguintes parâmetros são criados:

- `/${var.project_name}/vpc-id`
- `/${var.project_name}/public-subnet-ids`
- `/${var.project_name}/private-subnet-ids`
- `/${var.project_name}/pods-subnet-ids` (se criado)

Para usar os IDs de sub-redes em outros locais, você pode usar a função `split`:
`split(",", nonsensitive(data.aws_ssm_parameter.public_subnets.value))`

## Inputs

| Nome                     | Descrição                                                                | Tipo     | Padrão  | Obrigatório |
| ------------------------ | ------------------------------------------------------------------------ | -------- | ------- | :---------: |
| `project_name`           | Nome do projeto, usado como prefixo em tags e nomes de recursos.         | `string` | -       |     Sim     |
| `region`                 | Região AWS onde os recursos serão provisionados.                         | `string` | -       |     Sim     |
| `vpc_cidr_block`         | Bloco CIDR principal para a VPC.                                         | `string` | -       |     Sim     |
| `subnet_number`          | Número de sub-redes a serem criadas por tipo (públicas, privadas, etc.). | `number` | -       |     Sim     |
| `create_additional_cidr` | Se `true`, cria um CIDR adicional e sub-redes para pods.                 | `bool`   | `false` |     Não     |
| `additional_cidr`        | Bloco CIDR a ser associado à VPC para as sub-redes de pods.              | `string` | `""`    |     Não     |

## Outputs

| Nome                 | Descrição                                            |
| -------------------- | ---------------------------------------------------- |
| `vpc_id`             | O ID da VPC criada.                                  |
| `public_subnet_ids`  | A lista de IDs das sub-redes públicas.               |
| `private_subnet_ids` | A lista de IDs das sub-redes privadas.               |
| `pods_subnet_ids`    | A lista de IDs das sub-redes para pods (se criadas). |
