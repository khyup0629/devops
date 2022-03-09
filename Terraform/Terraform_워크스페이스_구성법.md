# 워크스페이스 구성법

기본적으로 리소스별, 용도별로 묶어서 구성합니다.   
![image](https://user-images.githubusercontent.com/43658658/157402265-a2a6fe5e-89a4-4cf2-8024-bf36203ffd27.png)

대부분의 데브옵스 엔지니어는 아래와 같이 워크스페이스 속을 구성하여 이용합니다.

## versions.tf

``` terraform
terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
```

## variables.tf

``` terraform
variable "config_file" {
  description = "The path of configuration YAML file."
  type        = string
  default     = "./config.yaml"
}
```   

- 기본적으로 variables.tf 파일은 `config_file`만 변수로 지정합니다.
- `default`에 `./config.yaml` 파일을 가리키도록 해서 config.yaml 파일 안에 변수들을 지정합니다.

## terraform.tf

`backend` 지정, local 변수, provider를 지정하는 파일입니다.

``` terraform
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "fastcampus-devops"

    workspaces {
      name = "aws-network-apne2-fastcampus"
    }
  }
}


###################################################
# Local Variables
###################################################

locals {
  aws_accounts = {
    fastcampus = {
      id     = "xxxxxxxxxx"
      region = "ap-northeast-2"
      alias  = "posquit0-fastcampus"
    },
  }
  context = yamldecode(file(var.config_file)).context
  config  = yamldecode(templatefile(var.config_file, local.context))
}


###################################################
# Providers
###################################################

provider "aws" {
  region = local.aws_accounts.fastcampus.region

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = [local.aws_accounts.fastcampus.id]

  assume_role {
    role_arn     = "arn:aws:iam::${local.aws_accounts.fastcampus.id}:role/terraform-access"
    session_name = local.context.workspace
  }
}
```

- `local` 변수를 보면 `yamldecode`를 볼 수 있는데 이는 yaml 파일을 HCL Object로 바꿔주는 역할을 합니다.
- `var.config_file`에는 `config.yaml` 파일의 path가 들어있습니다.
- `file`을 통해 path의 `config.yaml` 파일을 읽습니다.
- `context`와 `config`가 나눠진 이유는 `config.yaml` 파일을 보면 context 필드를 HCL Object로 먼저 빼내기 위함입니다.
- `templatefile`을 통해 config.yaml 파일의 내용 중 `${...}`의 내용들을 모두 context 필드를 참조해 렌더링 할 수 있습니다.

## config.yaml

``` yaml
context:
  region: "apne2"
  vpc: "apne2-fastcampus"
  cidrs:
    "primary": "10.222.0.0/16"
    "pod": "10.223.0.0/17"

remote_states:
  "domain-zone":
    organization: "fastcampus-devops"
    workspace: "aws-domain-zone"

prefix_lists:
  ipv4: []

vpc:
  name: "${vpc}"
  cidr: "${cidrs.primary}"
  secondary_cidrs:
  # EKS Pod CIDR
  - "${cidrs.pod}"
  vpn_gateway_asn: 4242000000
  private_zones:
  - "dev/dkr.ecr.ap-northeast-2.amazonaws.com"
  - "dev/sts.ap-northeast-2.amazonaws.com"

vpc_endpoints:
  interface: []
  gateway:
  - name: "${vpc}-gateway-aws-s3"
    service_name: "com.amazonaws.ap-northeast-2.s3"

subnet_groups:
  "app-private":
    subnets:
    - { cidr: "10.222.0.0/24", az_id: "${region}-az1" }
    - { cidr: "10.222.1.0/24", az_id: "${region}-az2" }
    - { cidr: "10.222.2.0/24", az_id: "${region}-az3" }
  "app-private-pod":
    subnets:
    - { cidr: "10.223.0.0/19", az_id: "${region}-az1" }
    - { cidr: "10.223.32.0/19", az_id: "${region}-az2" }
    - { cidr: "10.223.64.0/19", az_id: "${region}-az3" }
  "data-private-managed":
    subnets:
    - { cidr: "10.222.100.0/24", az_id: "${region}-az1" }
    - { cidr: "10.222.101.0/24", az_id: "${region}-az2" }
    - { cidr: "10.222.102.0/24", az_id: "${region}-az3" }
    db_subnet_group_name: "${vpc}-db-private"
    cache_subnet_group_name: "${vpc}-cache-private"
  "data-private-self":
    subnets:
    - { cidr: "10.222.103.0/24", az_id: "${region}-az1" }
    - { cidr: "10.222.104.0/24", az_id: "${region}-az2" }
    - { cidr: "10.222.105.0/24", az_id: "${region}-az3" }
  "net-public":
    map_public_ip_on_launch: true
    subnets:
    - { cidr: "10.222.230.0/24", az_id: "${region}-az1" }
    - { cidr: "10.222.231.0/24", az_id: "${region}-az2" }
    - { cidr: "10.222.232.0/24", az_id: "${region}-az3" }
  "net-private":
    subnets:
    - { cidr: "10.222.233.0/24", az_id: "${region}-az1" }
    - { cidr: "10.222.234.0/24", az_id: "${region}-az2" }
    - { cidr: "10.222.235.0/24", az_id: "${region}-az3" }

eip:
- "${vpc}-nat-gw/az1"
- "${vpc}-nat-gw/az2"
- "${vpc}-nat-gw/az3"

nat_gateways:
- az_id: "${region}-az1"
  eip: "${vpc}-nat-gw/az1"
- az_id: "${region}-az2"
  eip: "${vpc}-nat-gw/az2"
- az_id: "${region}-az3"
  eip: "${vpc}-nat-gw/az3"

nacl:
  "app-private":
    ingress_rules:
      # Ephemeral Ports
      800: { action: "allow", protocol: "tcp", cidr_block: "0.0.0.0/0", from_port: 1024, to_port: 65535 }
      801: { action: "allow", protocol: "udp", cidr_block: "0.0.0.0/0", from_port: 1024, to_port: 65535 }
      # Internal
      900: { action: "allow", protocol: "-1", cidr_block: "${cidrs.primary}" }
      901: { action: "allow", protocol: "-1", cidr_block: "${cidrs.pod}" }
    egress_rules:
      900: { action: "allow", protocol: "-1", cidr_block: "0.0.0.0/0" }
  "app-private-pod":
    ingress_rules:
      # Ephemeral Ports
      800: { action: "allow", protocol: "tcp", cidr_block: "0.0.0.0/0", from_port: 1024, to_port: 65535 }
      801: { action: "allow", protocol: "udp", cidr_block: "0.0.0.0/0", from_port: 1024, to_port: 65535 }
      # Internal
      900: { action: "allow", protocol: "-1", cidr_block: "${cidrs.primary}" }
      901: { action: "allow", protocol: "-1", cidr_block: "${cidrs.pod}" }
    egress_rules:
      900: { action: "allow", protocol: "-1", cidr_block: "0.0.0.0/0" }
  "data-private-managed":
    ingress_rules:
      # RDS - MySQL
      400: { action: "allow", protocol: "tcp", cidr_block: "${cidrs.primary}", from_port: 3306, to_port: 3306 }
      401: { action: "allow", protocol: "tcp", cidr_block: "${cidrs.pod}", from_port: 3306, to_port: 3306 }
      # MSK - Kafka
      410: { action: "allow", protocol: "tcp", cidr_block: "${cidrs.primary}", from_port: 2181, to_port: 2181 }
      411: { action: "allow", protocol: "tcp", cidr_block: "${cidrs.pod}", from_port: 2181, to_port: 2181 }
      420: { action: "allow", protocol: "tcp", cidr_block: "${cidrs.primary}", from_port: 9092, to_port: 9098 }
      421: { action: "allow", protocol: "tcp", cidr_block: "${cidrs.pod}", from_port: 9092, to_port: 9098 }
      422: { action: "allow", protocol: "tcp", cidr_block: "${cidrs.apne2-ops-dev}", from_port: 9092, to_port: 9098 }
      430: { action: "allow", protocol: "tcp", cidr_block: "${cidrs.primary}", from_port: 11001, to_port: 11002 }
      431: { action: "allow", protocol: "tcp", cidr_block: "${cidrs.pod}", from_port: 11001, to_port: 11002 }
      # Elasticache - Redis
      440: { action: "allow", protocol: "tcp", cidr_block: "${cidrs.primary}", from_port: 6379, to_port: 6379 }
      441: { action: "allow", protocol: "tcp", cidr_block: "${cidrs.pod}", from_port: 6379, to_port: 6379 }
    egress_rules:
      # Internal
      900: { action: "allow", protocol: "-1", cidr_block: "${cidrs.primary}" }
      901: { action: "allow", protocol: "-1", cidr_block: "${cidrs.pod}" }
  "data-private-self":
    ingress_rules:
      # Ephemeral Ports
      800: { action: "allow", protocol: "tcp", cidr_block: "0.0.0.0/0", from_port: 1024, to_port: 65535 }
      801: { action: "allow", protocol: "udp", cidr_block: "0.0.0.0/0", from_port: 1024, to_port: 65535 }
      # Internal
      900: { action: "allow", protocol: "-1", cidr_block: "${cidrs.primary}" }
      901: { action: "allow", protocol: "-1", cidr_block: "${cidrs.pod}" }
    egress_rules:
      900: { action: "allow", protocol: "-1", cidr_block: "0.0.0.0/0" }
  "net-public":
    ingress_rules:
      # ICMP
      100: { action: "allow", protocol: "icmp", cidr_block: "0.0.0.0/0", icmp_type: -1, icmp_code: -1 }
      # Management
      200: { action: "allow", protocol: "tcp", cidr_block: "0.0.0.0/0", from_port: 22, to_port: 22 }
      # 210: { action: "allow", protocol: "tcp", cidr_block: "0.0.0.0/0", from_port: 3389, to_port: 3389 }
      220: { action: "allow", protocol: "udp", cidr_block: "0.0.0.0/0", from_port: 1194, to_port: 1194 }
      # Load Balancer Ports
      300: { action: "allow", protocol: "tcp", cidr_block: "0.0.0.0/0", from_port: 80, to_port: 80 }
      310: { action: "allow", protocol: "tcp", cidr_block: "0.0.0.0/0", from_port: 443, to_port: 443 }
      # Ephemeral Ports
      800: { action: "allow", protocol: "tcp", cidr_block: "0.0.0.0/0", from_port: 1024, to_port: 65535 }
      801: { action: "allow", protocol: "udp", cidr_block: "0.0.0.0/0", from_port: 1024, to_port: 65535 }
      # Internal
      900: { action: "allow", protocol: "-1", cidr_block: "${cidrs.primary}" }
      901: { action: "allow", protocol: "-1", cidr_block: "${cidrs.pod}" }
    egress_rules:
      900: { action: "allow", protocol: "-1", cidr_block: "0.0.0.0/0" }
  "net-private":
    ingress_rules:
      # Internal
      900: { action: "allow", protocol: "-1", cidr_block: "${cidrs.primary}" }
      901: { action: "allow", protocol: "-1", cidr_block: "${cidrs.pod}" }
    egress_rules:
      # Internal
      900: { action: "allow", protocol: "-1", cidr_block: "${cidrs.primary}" }
      901: { action: "allow", protocol: "-1", cidr_block: "${cidrs.pod}" }
```

## terraform.auto.tfvars

`apply`를 하면 자동으로 실행되는 파일. `config_file` 변수의 값을 `config.yaml` 파일의 경로로 지정합니다.

``` terraform
config_file = "./config.yaml"
```

## remote-states.tf

각 워크스페이스 간에 의존성을 관리할 수 있도록 도와주는 remote-state

이 파일에서 각 워크스페이스 간에 어떤 관계가 있는 지를 한 눈에 볼 수 있도록 역할을 분담했습니다.

``` terraform
locals {
  remote_states = {
    "domain-zone" = data.terraform_remote_state.this["domain-zone"].outputs
  }
  domain_zones = local.remote_states["domain-zone"]
}


###################################################
# Terraform Remote States (External Dependencies)
###################################################

data "terraform_remote_state" "this" {
  for_each = local.config.remote_states

  backend = "remote"

  config = {
    organization = each.value.organization
    workspaces = {
      name = each.value.workspace
    }
  }
}
```

## outputs.tf

해당 워크스페이스에서 사용자에게 보여줘야하는 결과값들의 집합

``` terraform
output "config" {
  value = local.config
}

output "prefix_lists" {
  value = {
    ipv4 = {
      for name, prefix_list in aws_ec2_managed_prefix_list.ipv4 :
      name => {
        id      = prefix_list.id
        arn     = prefix_list.arn
        name    = prefix_list.name
        entries = prefix_list.entry
        version = prefix_list.version
      }
    }
    ipv6 = {
      for name, prefix_list in aws_ec2_managed_prefix_list.ipv6 :
      name => {
        id      = prefix_list.id
        arn     = prefix_list.arn
        name    = prefix_list.name
        entries = prefix_list.entry
        version = prefix_list.version
      }
    }
  }
}

output "vpc" {
  value = module.vpc
}

output "subnet_groups" {
  value = module.subnet_group
}

output "eip" {
  value = aws_eip.this
}

output "nat_gateway" {
  value = module.nat_gw
}

output "nacl" {
  value = module.nacl
}

output "gateway_endpoints" {
  value = module.vpc_gateway_endpoint
}
```

## .terraform-version

이 파일의 역할은 해당 워크스페이스에서 사용하는 테라폼 버전을 고정시키는 것입니다.

``` terraform
1.0.0
```

이 파일이 제 역할을 수행하도록 하려면 `tfswitch`라는 툴을 이용해야 합니다.   
=> [tfswitch 깃허브 사이트](https://github.com/warrensbox/terraform-switcher)

이 툴의 역할은 `.terraform-version`이 있는 디렉토리로 진입할 때 파일 내에 명시된 테라폼 버전이 자동으로 설치되도록 하는 것입니다.

깃허브 사이트에 들어가서 README를 수행하면 `tfswitch`가 정상적으로 작동합니다.


