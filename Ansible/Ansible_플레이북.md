# 플레이북(Playbook)

- `플레이북` (Playbook): YAML로 정의. 순서대로 정렬된 플레이(작업 목록) 절차.
- `플레이` (Play): 작업 목록(Tasks). 특정 호스트 목록에 대하여 수행
- `작업` (Task): 앤서블의 수행 단위. 애드혹 명령어는 한 번에 단일 작업 수행.
- `모듈` (Module): 앤서블이 실행하는 코드 단위. 작업에서 모듈을 호출함.
  - command, script, apt, service
- `콜렉션` (Collection): 모듈의 집합.

``` yaml
# Playbook
- name: Play 1
  hosts: ubuntu
  tasks:
  - name: "Task 1: Execute command"
    command: uptime

  - name: "Task 2: Execute script"
    script: task2.sh

  - name: "Task 3: Install package"
    apt:
      name: nginx
      state: present
      update_cache: true

  - name: "Task 4: Start nginx service"
    service:
      name: nginx
      state: started

- name: Play 2
  hosts: localhost
  tasks:
  - name: "Task 1: Execute command"
    command: whoami

  - name: "Task 2: Execute script"
    script: task2.sh
```

## 플레이북을 이용해 우분투, 아마존 리눅스에 nginx 패키지 설치하기

먼저 인벤토리 파일을 아래와 같이 작성합니다.   
```
# inventory

[amazon]
amazon1 ansible_host=13.209.11.129 ansible_user=ec2-user
amazon2 ansible_host=3.36.58.47 ansible_user=ec2-user

[ubuntu]
ubuntu1 ansible_host=ec2-3-34-135-32.ap-northeast-2.compute.amazonaws.com ansible_user=ubuntu
ubuntu2 ansible_host=ec2-52-79-202-181.ap-northeast-2.compute.amazonaws.com ansible_user=ubuntu

[linux:children]
amazon
ubuntu
```

다음으로 `ubuntu`, `amazon linux` 순서로 nginx 패키지를 설치하는 플레이북을 작성합니다.   
``` yaml
# install-nginx.yaml
- name: Install Nginx on Ubuntu
  hosts: ubuntu
  become: true
  tasks:
  - name: "Install Nginx"
    apt:
      name: nginx
      state: present
      update_cache: true

  - name: "Ensure nginx service started"
    service:
      name: nginx
      state: started

- name: Install Nginx on Amazon Linux
  hosts: amazon
  become: true
  tasks:
  # amazon linux에서는 nginx repository를 활성화 시켜줘야 합니다.
  - name: "Enable Nginx repository provided by Amazon"
    command: "amazon-linux-extras enable nginx1"

  - name: "Install Nginx"
    yum:
      name: nginx
      state: present

  - name: "Ensure nginx service started"
    service:
      name: nginx
      state: started
```

플레이북을 실행하는 명령어는 `ansible-playbook`입니다.

```
ansible-playbook -i inventory install-nginx.yaml
```

아래와 같이 설치가 진행됩니다.   
```
PLAY [Install Nginx on Ubuntu] *******************************************************

TASK [Gathering Facts] ***************************************************************
ok: [ubuntu1]
ok: [ubuntu2]

TASK [Install Nginx] *****************************************************************
changed: [ubuntu1]
changed: [ubuntu2]

TASK [Ensure nginx service started] **************************************************
ok: [ubuntu2]
ok: [ubuntu1]

PLAY [Install Nginx on Amazon Linux] *************************************************

TASK [Gathering Facts] ***************************************************************
[WARNING]: Platform linux on host amazon2 is using the discovered Python interpreter
at /usr/bin/python3.7, but future installation of another Python interpreter could
change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.12/reference_appendices/interpreter_discovery.html for more information.
ok: [amazon2]
[WARNING]: Platform linux on host amazon1 is using the discovered Python interpreter
at /usr/bin/python3.7, but future installation of another Python interpreter could
change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.12/reference_appendices/interpreter_discovery.html for more information.
ok: [amazon1]

TASK [Enable Nginx repository provided by Amazon] ************************************
changed: [amazon2]
changed: [amazon1]

TASK [Install Nginx] *****************************************************************
changed: [amazon2]
changed: [amazon1]

TASK [Ensure nginx service started] **************************************************
changed: [amazon2]
changed: [amazon1]

PLAY RECAP ***************************************************************************
amazon1                    : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
amazon2                    : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu1                    : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu2                    : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
