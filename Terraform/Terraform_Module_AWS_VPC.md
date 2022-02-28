# AWS VPC 생성

[테라폼 리포지토리의 AWS VPC 모듈](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)을 참고해 AWS VPC 인프라를 생성해보겠습니다.

```
mkdir test
cd test
vim main.tf
```

``` terraform
# main.tf
provider "aws" {

}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["apne2-az1", "apne2-az2", "apne2-az3"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```

```
terraform init  // Provider와 Module을 다운 받습니다.
terraform apply  // main.tf 파일을 적용시켜 VPC 인프라를 생성합니다.
```

**AWS 콘솔**에 리소스가 생성되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/155933813-937c305c-bca1-4720-b158-d5ebaa8b3054.png)   
![image](https://user-images.githubusercontent.com/43658658/155933855-dce1a542-ca74-4a2b-bd57-3f19728eb755.png)   
![image](https://user-images.githubusercontent.com/43658658/155933899-2cdecc85-0671-40c6-ba98-70a7b6be3d4b.png)   
![image](https://user-images.githubusercontent.com/43658658/155933924-470247bf-ffca-4c9b-bcef-c3dfa4e870ce.png)   

생성한 인프라를 모두 제거해봅시다.   
```
terraform destroy
```

