# AWS EC2 생성하기

[Terraform AWS EC2 모듈](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)을 이용해 EC2 인스턴스를 생성해보겠습니다.

```
mkdir test
cd test
vim main.tf
```

## 싱글 인스턴스 생성

``` terraform
# main.tf
provider "aws" {
  region = "ap-northeast-2"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = "ami-0454bb2fefc7de534"   # 이미지 id
  instance_type          = "t2.micro"
  key_name               = "mykeypair"   # 키 페어 이름
  monitoring             = true
  vpc_security_group_ids = ["sg-c7e25bb6"]   # 보안그룹 id
  subnet_id              = "subnet-f70f849c"   # 서브넷 id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```   
![image](https://user-images.githubusercontent.com/43658658/155981742-a9159713-23ba-4129-a6fd-4f113f689155.png)   
![image](https://user-images.githubusercontent.com/43658658/155981756-67b76ba6-ecc5-4c73-932e-208d89f8eccd.png)   
![image](https://user-images.githubusercontent.com/43658658/155981769-ba2b6400-df92-4bcb-a861-eec52a302e30.png)   
![image](https://user-images.githubusercontent.com/43658658/155981788-0034137e-1a1c-4628-9620-bf5fee5d3208.png)

```
terraform init
terraform apply
```

정상적으로 인스턴스가 실행되는 것을 확인할 수 있습니다.  
![image](https://user-images.githubusercontent.com/43658658/155981962-c2362081-2e89-4883-9b46-1cfef6b2a9d0.png)


