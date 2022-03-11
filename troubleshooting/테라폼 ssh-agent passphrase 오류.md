# 테라폼 ssh-agent 

EC2 서버를 만들고 특정 명령어를 프로비저닝하는 테라폼 코드를 작성하고 `terraform apply` 명령 수행 시 아래와 같은 메시지가 발생합니다.

```
Failed to parse ssh private key: ssh: this private key is passphrase protected
```

그리고 [ssh-agent 설정하기(windows)]()의 내용대로 `ssh-add` 까지 진행했음에도 불구하고 여전히 아래와 같이 플랜에서 `SSH Agent: false`가 나타납니다.   

```
aws_instance.provisioner (remote-exec):   SSH Agent: false
```

## 해결법

이는 단순히 프로비저닝할 때 `ssh-agent`를 사용할 것인지에 대한 여부를 명시하지 않았기 때문입니다.

```
# main.tf
resource "aws_instance" "provisioner" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  key_name      = "root-hyeob"

  vpc_security_group_ids = [
    module.security_group.id,
  ]

  tags = {
    Name = "fastcampus-provisioner"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      host = self.public_ip
      agent = true     # <------------------------ ssh-agent를 사용하겠다고 명시합니다.
    }
  }
}
```

- `connection` 부분에서 `agent = true` 속성을 주게 되면 ssh-agent가 정상 작동합니다.

