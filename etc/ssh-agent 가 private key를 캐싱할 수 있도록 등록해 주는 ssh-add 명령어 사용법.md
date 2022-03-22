# ssh-agent 가 private key를 캐싱할 수 있도록 등록해 주는 ssh-add 명령어 사용법

`openSSH`에는 `ssh-agent` 라는 `authentication agent`가 있어서 **pass phrase**를 입력한 **private key**를 메모리에 캐싱해 줍니다.

이 덕분에 한 번 개인 키를 입력했으면 다시 입력할 필요없이 세션이 유지되는 동안 편리하게 사용할 수 있습니다.

`ssh-add` 명령은 ssh-agent 에게 캐싱할 **개인 키를 등록**해 주는 역할을 수행합니다.

## ssh-add로 private key 캐싱하기

먼저 원하는 `private key`를 우분투 서버에 넣습니다.

```
ssh-add <private key 파일 경로>
```

만약 아래의 에러가 발생한다면 이는 한 번도 ssh-agent를 사용하지 않았을 때 발생하는 에러이므로 아래의 명령을 입력해 ssh-agent를 시작합니다.   
![image](https://user-images.githubusercontent.com/43658658/159402014-41bc1c6c-5a3b-42c4-b0a3-9f64fcc69416.png)   
```
eval $(ssh-agent)
```

다시 `ssh-add`를 실행하면 성공적으로 등록됩니다.   

아래의 에러가 발생한다면 `private key` 파일의 권한 문제로 `600`으로 권한을 주면 해결됩니다.   
![image](https://user-images.githubusercontent.com/43658658/159402672-24cb1027-1ad7-441a-b272-2f20aa836511.png)   
```
chmod 600 <private key 파일 경로>
```

다시 `ssh-add`를 실행하면 성공적으로 등록됩니다.   


## ssh-add -l

ssh-agent 에 등록된 개인 키의 목록을 보려면 -l 옵션을 사용하면 전체 개인 키의 목록을 표시합니다.

```
$ ssh-add -l
```

## 삭제

삭제하려면 `-d` 옵션 뒤에 삭제할 개인 키의 경로를 적어주면 됩니다.

```
$ ssh-add -d <private key 파일 경로>
```

전체 개인키를 삭제하려면 `-D` 옵션을 주고 실행합니다.

```
$ ssh-add -D
```
