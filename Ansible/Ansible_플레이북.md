# 플레이북(Playbook)

- `플레이북` (Playbook): YAML로 정의. 순서대로 정렬된 플레이(작업 목록) 절차.
- `플레이` (Play): 작업 목록(Tasks). 특정 호스트 목록에 대하여 수행
- `작업` (Task): 앤서블의 수행 단위. 애드혹 명령어는 한 번에 단일 작업 수행.
- `모듈` (Module): 앤서블이 실행하는 코드 단위. 작업에서 모듈을 호출함.
  - command, script, apt, service
- `콜렉션` (Collection): 모듈의 집합.

```
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

```
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

