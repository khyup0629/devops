# 애드혹 명령어(Ad-hoc Command)

앤서블을 사용하는 방법 중 하나로 많이 사용하는 방법입니다.

`앤서블 플레이북`을 작성하지 않고, **직접 명령**해서 해당 명령어를 실행합니다.

- 간단하지만, 재사용하기는 어렵습니다.

**애드혹 명령어**는 아래와 같은 형식으로 사용합니다.   
(순서를 지킬 필요는 없습니다)   
```
ansible <그룹명> -m <모듈명> [-a <모듈 옵션명>] [-i <인벤토리 파일명>]
```

아래의 명령으로 `ping`을 보내보겠습니다.   
(여기서 `ping`은 네트워크에서 말하는 ping이 아니라 대상 호스트에 연결 후 **python 사용 가능 여부**를 확인하는 명령어입니다)   
```
ansible -i amazon.inv -m ping all
```

(여기서 잠깐!) AWS 인스턴스와 연결하기 위해서는 사전에 우분투 서버의 ssh-agent에 인스턴스의 `private key`가 등록되어 있어야 합니다.   
=> [ssh-agent 가 private key를 캐싱할 수 있도록 등록해 주는 ssh-add 명령어 사용법](https://github.com/khyup0629/devops/blob/main/etc/ssh-agent%20%EA%B0%80%20private%20key%EB%A5%BC%20%EC%BA%90%EC%8B%B1%ED%95%A0%20%EC%88%98%20%EC%9E%88%EB%8F%84%EB%A1%9D%20%EB%93%B1%EB%A1%9D%ED%95%B4%20%EC%A3%BC%EB%8A%94%20ssh-add%20%EB%AA%85%EB%A0%B9%EC%96%B4%20%EC%82%AC%EC%9A%A9%EB%B2%95.md#ssh-agent-%EA%B0%80-private-key%EB%A5%BC-%EC%BA%90%EC%8B%B1%ED%95%A0-%EC%88%98-%EC%9E%88%EB%8F%84%EB%A1%9D-%EB%93%B1%EB%A1%9D%ED%95%B4-%EC%A3%BC%EB%8A%94-ssh-add-%EB%AA%85%EB%A0%B9%EC%96%B4-%EC%82%AC%EC%9A%A9%EB%B2%95)

만약 ssh-agent를 사용하지 않지만 ssh key를 통해서 접근하고 싶다고 한다면,   
```
ansible -i amazon.inv -m ping all -u ec2-user --private-key <private key 파일 경로>
```   
`--private-key` 옵션을 통해 `private key 파일 경로`를 명시해 접근할 수도 있습니다.

아래 실습은 `ssh-agent`를 사용한다는 전제로 작성되었습니다.

아래의 에러가 나타나는데 이는 `amazon linux` 운영체제 서버로 접근할 때 사용자명을 설정해주지 않아 발생하는 문제입니다.   
사용자명을 명시하지 않으면 디폴트로 현재 우분투 서버의 사용자명으로 접근하게 됩니다.   
```
13.209.11.129 | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: hyeob@13.209.11.129: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).",
    "unreachable": true
}
yes
3.36.58.47 | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: Warning: Permanently added '3.36.58.47' (ECDSA) to the list of known hosts.\r\nhyeob@3.36.58.47: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).",
    "unreachable": true
}
```

사용자명을 명시한 새로운 명령어를 작성해 실행해보겠습니다.   
```
ansible -i amazon.inv -m ping all -u ec2-user
```   

정상적으로 핑이 갑니다.   
![image](https://user-images.githubusercontent.com/43658658/159404447-6a2dd1ce-70c6-44dd-a19f-876f73dcbb8b.png)

