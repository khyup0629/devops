# Ansible 변수 선언

변수는 `플레이북`에 직접 입력하는 방법과 `인벤토리` 파일에 입력하는 2가지 방법이 있습니다.

## 플레이북에 선언하는 방법

``` yaml
# playbook.yaml
---

- name: Example
  hosts: ubuntu
  become: true
  vars:
    user_name: "posquit0"
    user_comment: "from playbook vars"
    user_shell: /bin/bash
    user_uid: "7777"
  # vars_files:
  # - vars.yaml
  tasks:
  - name: "Create a user"
    user:
      name: "{{ user_name }}"
      comment: "{{ user_comment }}"
      shell: "{{ user_shell }}"
      uid: "{{ user_uid }}"
```

- `vars` : 밑에 key-value 형식으로 변수들을 정의하고 아래에서 `jinja2` 템플릿 형식으로 표현할 수 있습니다.
- `vars_files` : 밑에 `yaml` 형식으로 변수가 정의된 파일들을 명시하면 해당 파일에 선언된 변수들을 사용할 수 있습니다.

해당 플레이북을 실행하고, ubuntu 서버에 ssh 접속으로 접근해서 유저 정보를 확인해보면 변수에 선언된 값들이 들어간 것을 확인할 수 있습니다.

```
ssh ubuntu@ec2-13-124-77-230.ap-northeast-2.compute.amazonaws.com
```

```
cat /etc/passwd
```

![image](https://user-images.githubusercontent.com/43658658/159855000-585e2d9c-eedf-4f45-b077-2749ddca3296.png)


## 인벤토리 파일에 선언하는 방법

`플레이북`에서 별다른 변수를 선언하지 않고, 이 `인벤토리` 파일을 이용해서 실행하면 변수를 사용할 수 있습니다.

```
# vars.inv
[amazon]
amazon1 ansible_host=3.35.53.163 ansible_user=ec2-user
amazon2 ansible_host=3.34.253.165 ansible_user=ec2-user

[ubuntu]
ubuntu1 ansible_host=ec2-3-34-49-77.ap-northeast-2.compute.amazonaws.com ansible_user=ubuntu user_name=posquit0 user_comment="from inventory" user_shell=/bin/bash user_uid=7777
ubuntu2 ansible_host=ec2-13-209-20-108.ap-northeast-2.compute.amazonaws.com ansible_user=ubuntu user_name=posquit0 user_comment="from inventory" user_shell=/bin/bash user_uid=7777

[linux:children]
amazon
ubuntu
```

## 커맨드 라인을 통해서 변수를 선언하는 방법

명령을 실행할 때 `-e` 옵션을 주고 스페이스를 기준으로 선언한 변수들의 값을 직접 입력해서 넘겨줄 수도 있습니다.

```
ansible-playbook -i default.inv -e "user_comment=helloworld user_shell=/bin/sh" playbook.yaml
```

커맨드라인을 실행하게 되면 기존에 파일에 선언된 변수들의 값에 덮어쓰고, 명령을 전달합니다.
![image](https://user-images.githubusercontent.com/43658658/159856593-c9b33a41-f2df-428a-8850-5b6ae546721b.png)

한편, `-e` 옵션에 "@<변수파일이름>"을 통해 변수 파일을 넘겨줄 수도 있습니다.

```
ansible-playbook -i default.inv -e "@vars.yaml" playbook.yaml
```

![image](https://user-images.githubusercontent.com/43658658/159856897-5095c529-6953-4c29-a658-e98ec08aac95.png)


