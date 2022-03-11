# SSH Agent(Windows)

`SSH Agent` : 인스턴스에 접근할 때 password와 private_key를 미리 등록해서 이후 서버에 접근할 때 해당 항목을 요구하지 않도록 하는 역할 수행.

- 코드 상 기밀 데이터가 남지 않아 **보안이 우수**합니다.   
(일반적으로 SSH로 인스턴스에 접근하려면 코드에 비밀번호와 인증 키에 대한 정보가 명시되어야 하기 때문입니다)

운영체제에 인증 키를 등록해주는 과정이 필요합니다.

=> [SSH Agent on Windows 참고 사이트](https://docs.microsoft.com/ko-kr/windows-server/administration/openssh/openssh_keymanagement)

## 키 페어 파일 생성

먼저 Powershell을 관리자 권한으로 실행하고, 키 페어를 Ed25519 알고리즘으로 생성합니다.   
```
ssh-keygen -t ed25519
```

아래와 같이 나타나면, 키 페어 파일이 저장될 위치를 적어줄 수 있습니다.   
```
Generating public/private ed25519 key pair.
Enter file in which to save the key (C:\Users\hongikit/.ssh/id_ed25519): C:\Users\hongikit\.ssh\root-hyeob-keypair
```

암호를 등록할 수 있습니다. 이 암호는 2단계 인증을 제공하고, 입력하지 않고 엔터로 스킵할 수도 있지만 권장되진 않습니다.   
```
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```

정상적으로 키 페어 파일이 생성되면 아래와 같이 나타납니다.   
```
The key's randomart image is:
+--[ED25519 256]--+
|        .        |
|         o       |
|    . + + .      |
|   o B * = .     |
|   o= B S .      |
|   .=B O o       |
|  + =+% o        |
| *oo.O.E         |
|+.o+=o. .        |
+----[SHA256]-----+
```

## 프라이빗 키 파일 저장

이제 키 페어 파일이 저장된 경로로 이동합니다.   
```
cd <키 페어 파일 경로>
```

ssh-agent의 시작 타입을 `수동`으로 변경합니다.   
```
Get-Service ssh-agent | Set-Service -StartupType Manual
```

ssh-agent를 실행합니다.   
```
Start-Service ssh-agent
```

실행 상태를 확인합니다.   
```
Get-Service ssh-agent
```

프라이빗 키 파일을 `ssh-add`를 통해 **운영체제에 저장**합니다.   
```
ssh-add <프라이빗 키 파일 이름>
```

## 퍼블릭 키 파일 배포

위에서 만든 사용자 키를 사용하려면 공개 키(~\.ssh\id_ed25519.pub)의 콘텐츠를 서버의 `C:\Users\<username>\.ssh\`에 있는 `authorized_keys`라는 텍스트 파일에 배치되어야 합니다.

```
ssh hongikit@domain1@contoso.com mkdir C:\Users\hongikit\.ssh\
```



