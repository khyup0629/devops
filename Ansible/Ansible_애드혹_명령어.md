# 애드혹 명령어(Ad-hoc Command)

앤서블을 사용하는 방법 중 하나로 많이 사용하는 방법입니다.

`앤서블 플레이북`을 작성하지 않고, **직접 명령**해서 해당 명령어를 실행합니다.

- 간단하지만, 재사용하기는 어렵습니다.

**애드혹 명령어**는 아래와 같은 형식으로 사용합니다.   
(순서를 지킬 필요는 없습니다)   
```
ansible <그룹명> -m <모듈명> [-a <모듈 옵션명>] [-i <인벤토리 파일명>]
```

## ping 모듈 활용

앤서블에서 `ping` 모듈은 네트워크에서 말하는 ping이 아니라 대상 호스트에 연결 후 **python 사용 가능 여부**를 확인하는 역할을 합니다.

아래의 명령으로 `ping`을 보내보겠습니다.   
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

## command 모듈 활용

`command` 모듈은 대상 호스트 안에서 명령어를 수행할 수 있도록 합니다.   

`vars.inv` 안에서 `ubuntu` 그룹의 호스트들로 접근해 `uptime` 명령을 실행해 해당 서버가 실행되고 있는 시간을 출력해봅니다.

```
ansible -i vars.inv -m command -a "uptime" ubuntu
```

```
ubuntu1 | CHANGED | rc=0 >>
 04:01:46 up  1:33,  1 user,  load average: 0.16, 0.03, 0.01

ubuntu2 | CHANGED | rc=0 >>
 04:01:55 up  1:33,  1 user,  load average: 0.00, 0.00, 0.00
```

## setup 모듈 활용

`setup` 모듈은 상세(Facts)를 수집하는 모듈입니다.

```
ansible localhost -m setup
```   
(앤서블에서는 `localhost`도 해석됩니다)

아래는 현재 localhost 상세 정보 결과값입니다.   
```
localhost | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "172.17.0.1",
            "172.16.0.202",
            "172.20.0.1"
        ],
        "ansible_all_ipv6_addresses": [
            "fe80::42:3dff:fe82:a1cd",
            "fe80::20c:29ff:feee:de2f",
            "fe80::e4a1:10ff:fed3:dc4d",
            "fe80::900c:a5ff:fe67:bdec",
            "fe80::2412:79ff:fe5b:5732",
            "fe80::42:5aff:fef0:d6a0",
            "fe80::c83a:81ff:fe80:2e7b",
            "fe80::b8b7:54ff:fe76:bcf6",
            "fe80::6410:e2ff:fec5:f52",
            "fe80::8029:4bff:fe76:2549",
            "fe80::140b:d2ff:fe8e:b1ec",
            "fe80::60b7:e9ff:fed7:132",
            "fe80::24c8:44ff:fef5:6f"
        ],
        "ansible_apparmor": {
            "status": "enabled"
        },
        "ansible_architecture": "x86_64",
        "ansible_bios_date": "12/12/2018",
        "ansible_bios_vendor": "Phoenix Technologies LTD",
        "ansible_bios_version": "6.00",
        "ansible_board_asset_tag": "NA",
        "ansible_board_name": "440BX Desktop Reference Platform",
        "ansible_board_serial": "NA",
        "ansible_board_vendor": "Intel Corporation",
        "ansible_board_version": "None",
        "ansible_br_dbdae2c84833": {
```

상세 정보는 앞에 접두어(prefix)로 `ansible_`이 붙어 모두 앤서블 변수로 정의됩니다.

## apt 모듈 활용

apt 모듈은 우분투에서 패키지를 관리하는 명령어입니다.   

`Git`을 최신 모듈로 다운 받아보겠습니다.   
(`--become` 옵션을 주면 관리자 권한으로 명령을 실행할 수 있습니다)   

```
ansible -i vars.inv -m apt -a "name=git state=latest update_cache=yes" ubuntu --become
```

`command` 모듈을 이용해 `git`이 제대로 설치되었는지 확인해봅시다.   
```
ansible -i vars.inv -m command -a "git --version" ubuntu
```

```
ubuntu2 | CHANGED | rc=0 >>
git version 2.25.1
ubuntu1 | CHANGED | rc=0 >>
git version 2.25.1
```

패키지를 `삭제`하고 싶다면 `state=absent`로 입력합니다.   

```
ansible -i vars.inv -m apt -a "name=git state=absent update_cache=yes" ubuntu --become
```




