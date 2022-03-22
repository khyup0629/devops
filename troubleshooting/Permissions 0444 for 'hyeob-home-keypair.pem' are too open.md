# Permissions 0444 for 'hyeob-home-keypair.pem' are too open.

`ssh-add` 명령을 실행하는 과정에서 아래의 에러메시지가 나타났습니다.

```
hyeob@hyeob:~/private-key$ ssh-add hyeob-home-keypair.pem
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0444 for 'hyeob-home-keypair.pem' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
```


## 해결 방법

`private key` 파일의 권한 문제로 `600`으로 권한을 주면 해결됩니다.   

```
chmod 600 <private key 파일 경로>
```


다시 `ssh-add`를 실행하면 성공적으로 등록됩니다. 

