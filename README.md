# Módulo VPC

## Introdução

Este módulo Terraform provisiona um ambiente de Virtual Private Cloud (VPC) dinamicamente configurável na AWS. Ele cria uma VPC com sub-redes públicas e privadas, um gateway de internet, um gateway NAT, tabelas de roteamento e um endpoint de VPC para S3. Opcionalmente, ele pode associar um bloco CIDR adicional à VPC e criar sub-redes para pods com base em uma variável condicional, tornando-o adequado para cargas de trabalho como clusters Kubernetes que requerem capacidade extra de sub-redes.

## Funcionalidades

- Cria uma VPC com um bloco CIDR definido pelo usuário.
- Provisiona dinamicamente sub-redes públicas e privadas em várias zonas de disponibilidade.
- Configura um Gateway de Internet para acesso à internet das sub-redes públicas.
- Implanta um Gateway NAT em uma sub-rede pública para conectividade à internet das sub-redes privadas.
- Configura tabelas de roteamento separadas para sub-redes públicas e privadas.
- Opcionalmente, associa um bloco CIDR adicional à VPC e cria sub-redes para pods dentro dele.
- Estabelece um endpoint de VPC para S3 associado à tabela de roteamento privada para acesso privado ao S3.

## Pré-requisitos

- Terraform instalado (versão 6.7.0 ou superior recomendada).
- Credenciais AWS configuradas com permissões para criar VPCs, sub-redes, gateways e endpoints.
- A região AWS de destino deve ter pelo menos tantas zonas de disponibilidade quanto o valor da variável `subnet_number`.

## Uso

Para utilizar este módulo, inclua-o em sua configuração Terraform e especifique as variáveis necessárias. Variáveis opcionais podem ser definidas para habilitar recursos adicionais, como sub-redes para pods.

### Variáveis Obrigatórias

- **`project_name`**: Uma string para nomear o projeto, usada em tags de recursos (por exemplo, "meu-projeto").
- **`region`**: A região AWS para implantação dos recursos (por exemplo, "us-west-2").
- **`vpc_cidr_block`**: O bloco CIDR para a VPC (por exemplo, "10.0.0.0/16").
- **`subnet_number`**: O número de sub-redes a serem criadas por tipo (públicas, privadas e, opcionalmente, pods) (por exemplo, 2).

### Variáveis Opcionais

- **`additional_cidr`**: Um bloco CIDR a ser associado à VPC para sub-redes de pods (por exemplo, "10.1.0.0/16"). Necessário se `create_additional_cidr` for `true`.
- **`create_additional_cidr`**: Um booleano para determinar se deve criar sub-redes para pods e associar um CIDR adicional (padrão: `false`).

### Notas sobre Recursos Opcionais

As sub-redes para pods são um recurso opcional controlado pela variável `create_additional_cidr`. Se definido como `true`, o módulo:
- Associa o bloco `additional_cidr` à VPC.
- Cria sub-redes para pods com blocos CIDR derivados de `additional_cidr`.
- Associa essas sub-redes à tabela de roteamento privada.
- Acesse a documenteção da AWS para consultar quais ranges são válidos.
- Se `false`, nenhum CIDR adicional ou sub-redes para pods são criados, mantendo a configuração mais simples.

### Parameter Store

O módulo também pode ser configurado para armazenar as variáveis de configuração no AWS Systems Manager Parameter Store, facilitando a gestão e recuperação dessas informações em outros módulos ou aplicações.

- "/${var.project_name}/vpc-id"
- "/${var.project_name}/public-subnet-ids"
- "/${var.project_name}/private-subnet-ids"
- "/${var.project_name}/pods-subnet-ids"

Utilize a função split para iterar sobre os elementos values do parameter store de subnets.
- split(",", nonsensitive(data.aws_ssm_parameter.pods_subnets.value))
## Exemplo

Aqui está um exemplo de configuração Terraform usando este módulo:

```hcl
module "vpc" {
  source  = "LucasCloudUniverse/vpc/aws"
  version = "1.0.0"

  project_name          = "meu-projeto"
  region                = "us-west-2"
  vpc_cidr_block        = "10.0.0.0/16"
  subnet_number         = 3
  create_additional_cidr = true
  additional_cidr       = "100.64.0.0/16"
}
```
