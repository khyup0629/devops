# 테라폼 설치(우분투)

아래 공식 문서를 참고하여 테라폼을 운영체제 별로 설치할 수 있습니다.   
=> [AWS용 Terraform 설치 공식 메뉴얼](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started#install-terraform)

`Linux`에서 `Ubuntu/Debain`을 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/155710340-499dfc88-bc00-48df-b1de-4d14f33d4aab.png)

테라폼 설치에 필요한 `의존성 패키지`들을 설치합니다.   
```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
```

HarshiCorp의 `GPG key`(테라폼을 쓸 수 있도록 인증하는 키)를 다운로드 받아서 추가합니다.   
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
```

HarshiCorp의 `리눅스 레포지토리`를 추가합니다.   
```
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```

레포지토리를 업데이트하고, `Terraform CLI`를 설치합니다.
```
sudo apt-get update && sudo apt-get install terraform
```

테라폼이 정상적으로 설치되었는지 확인합니다.   
```
which terraform
terraform version
```   
![image](https://user-images.githubusercontent.com/43658658/155711171-3adfcb0a-9907-42c7-9c35-c5ec0920525e.png)

## 명령어 자동 완성 설정(Bash 용)

`Tab`키를 눌러 명령어가 자동완성 될 수 있도록 설정해보겠습니다.   
=> [Terraform 명령어 자동 완성 설정](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started#enable-tab-completion)

`.bashrc` 파일을 하나 만듭니다.   
```
touch ~/.bashrc
```

`autocomplete`(자동완성) 패키지를 설치합니다.   
```
terraform -install-autocomplete
```   

`.bashrc` 파일을 살펴보면 가장 아래에 자동완성과 관련된 설정이 추가된 것을 확인할 수 있습니다.   
```
cat ~/.bashrc
```   
![image](https://user-images.githubusercontent.com/43658658/155712243-d802d1b6-b87d-4adc-8ffc-cee5147be4a3.png)

자동완성 설정을 적용하기 위해 `bash` 명령으로 bash shell을 다시 시작합니다.   
```
bash
```

이제 명령줄에 `terraform`을 입력하고, `Tab | Tab`을 누르면 자동완성 할 수 있는 명령어들이 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/155712468-61c1ad46-848a-438b-b84c-de24be4764ab.png)

## 캐시 디렉토리 설정

테라폼을 사용하게 되면 많은 워크스페이스들을 다루게 되고,   
각 워크스페이스 별로 필요한 **provider 또는 module**을 설치하게 됩니다.

**캐시 디렉토리를 설정하지 않으면** 각 워크스페이스의 `~/.terraform.d` 디렉토리 안에 **provider 또는 module**을 설치하게 됩니다.   
워크스페이스가 많아질 수록, 각각 설치된 **provider, module**로 인해 저장 공간이 부족하게 됩니다.

따라서, `plugin-cache` 캐싱 디렉토리를 설정하면 **provider 또는 module**를 설치할 때 캐싱 디렉토리 안에 **캐싱**되고,   
각 워크스페이스들이 해당 디렉토리를 공유하게 되므로 **중앙집중식**의 효율적인 관리를 할 수 있습니다.

=> [CLI Configuration File](https://www.terraform.io/cli/config/config-file)

테라폼 config는 `.terraformrc` 파일 안에서 작성됩니다.   

`.terraformrc` 파일을 생성합니다.   
```
vim ~/.terraformrc
```

#### .terraformrc

**캐시 디렉토리**를 설정합니다.   
```
plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache"
```

다음으로, 위에서 설정한 캐시 디렉토리를 만듭니다.   
```
mkdir -p ~/.terraform.d/plugin-cache
```

이제 **provider 또는 module**이 이 캐싱 디렉토리 내에 **캐싱**됩니다.
