# 앤서블 조건문

앤서블에서 조건문은 `when` 속성으로 작성할 수 있습니다.

``` yaml
---

- name: Example
  hosts: all
  become: true
  vars:
    users:
    - name: john
      shell: /bin/bash
      enabled: true
    - name: alice
      shell: /bin/sh
      enabled: false
    - name: claud
      shell: /bin/bash
      enabled: true
    - name: henry
      shell: /bin/sh
      enabled: false
    - name: jeremy
      shell: /bin/bash
      enabled: true
    - name: may
      shell: /bin/sh
      enabled: false
  tasks:
  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
  - name: "Create a user if enabled in Amazon Linux"
    user:
      name: "{{ item.name }}"
      shell: "{{ item.shell }}"
      comment: "FastCampus DevOps"
      state: "present"
    loop: "{{ users }}"
    when: item.enabled and (ansible_facts["distribution"] == "Amazon")

  - name: "Show items between 10 and 100"
    debug:
      var: item
    loop: [ 0, 192, 154, 456, 7, 2, -1, 55, 234]
    when:
    - item >= 10
    - item <= 100

  - name: "Show items not between 10 and 100"
    debug:
      var: item
    loop: [ 0, 192, 154, 456, 7, 2, -1, 55, 234]
    when:
    - (item < 10) or (item > 100)

  - name: "Install Packages on Ubuntu"
    apt:
      name: "{{ item }}"
      update_cache: true
      state: "present"
    loop:
    - git
    - curl
    - htop
    when:
    - ansible_facts['distribution'] == 'Ubuntu'

  - name: "Install Packages on Amazon Linux"
    yum:
      name: "{{ item }}"
      state: "present"
    loop:
    - git
    - curl
    - htop
    when:
    - ansible_facts['distribution'] == 'Amazon'

  - name: "Print users"
    command: "cut -d: -f1 /etc/passwd"
    register: users

  - name: "Is there claud"
    debug:
      msg: "There is no claud"
    when: users.stdout.find('claud') == -1
```

### 결과값

```
TASK [Create a user if enabled in Amazon Linux] **************************************
skipping: [ubuntu1] => (item={'name': 'john', 'shell': '/bin/bash', 'enabled': True})
skipping: [ubuntu2] => (item={'name': 'john', 'shell': '/bin/bash', 'enabled': True})
skipping: [ubuntu2] => (item={'name': 'alice', 'shell': '/bin/sh', 'enabled': False})
skipping: [ubuntu2] => (item={'name': 'claud', 'shell': '/bin/bash', 'enabled': True})
skipping: [ubuntu2] => (item={'name': 'henry', 'shell': '/bin/sh', 'enabled': False})
skipping: [ubuntu1] => (item={'name': 'alice', 'shell': '/bin/sh', 'enabled': False})
skipping: [ubuntu1] => (item={'name': 'claud', 'shell': '/bin/bash', 'enabled': True})
skipping: [ubuntu2] => (item={'name': 'jeremy', 'shell': '/bin/bash', 'enabled': True})
skipping: [ubuntu2] => (item={'name': 'may', 'shell': '/bin/sh', 'enabled': False})
skipping: [ubuntu1] => (item={'name': 'henry', 'shell': '/bin/sh', 'enabled': False})
skipping: [ubuntu1] => (item={'name': 'jeremy', 'shell': '/bin/bash', 'enabled': True})
skipping: [ubuntu1] => (item={'name': 'may', 'shell': '/bin/sh', 'enabled': False})
ok: [amazon2] => (item={'name': 'john', 'shell': '/bin/bash', 'enabled': True})
skipping: [amazon2] => (item={'name': 'alice', 'shell': '/bin/sh', 'enabled': False})
changed: [amazon1] => (item={'name': 'john', 'shell': '/bin/bash', 'enabled': True})
skipping: [amazon1] => (item={'name': 'alice', 'shell': '/bin/sh', 'enabled': False})
ok: [amazon2] => (item={'name': 'claud', 'shell': '/bin/bash', 'enabled': True})
skipping: [amazon2] => (item={'name': 'henry', 'shell': '/bin/sh', 'enabled': False})
changed: [amazon1] => (item={'name': 'claud', 'shell': '/bin/bash', 'enabled': True})
skipping: [amazon1] => (item={'name': 'henry', 'shell': '/bin/sh', 'enabled': False})
ok: [amazon2] => (item={'name': 'jeremy', 'shell': '/bin/bash', 'enabled': True})
skipping: [amazon2] => (item={'name': 'may', 'shell': '/bin/sh', 'enabled': False})
changed: [amazon1] => (item={'name': 'jeremy', 'shell': '/bin/bash', 'enabled': True})
skipping: [amazon1] => (item={'name': 'may', 'shell': '/bin/sh', 'enabled': False})

TASK [Show items between 10 and 100] *************************************************
skipping: [amazon1] => (item=0)
skipping: [amazon1] => (item=192)
skipping: [amazon1] => (item=154)
skipping: [amazon1] => (item=456)
skipping: [amazon1] => (item=7)
skipping: [amazon1] => (item=2)
skipping: [amazon1] => (item=-1)
ok: [amazon1] => (item=55) => {
    "ansible_loop_var": "item",
    "item": 55
}
skipping: [amazon1] => (item=234)
skipping: [amazon2] => (item=0)
skipping: [amazon2] => (item=192)
skipping: [amazon2] => (item=154)
skipping: [amazon2] => (item=456)
skipping: [amazon2] => (item=7)
skipping: [amazon2] => (item=2)
skipping: [amazon2] => (item=-1)
skipping: [ubuntu1] => (item=0)
ok: [amazon2] => (item=55) => {
    "ansible_loop_var": "item",
    "item": 55
}
skipping: [ubuntu1] => (item=192)
skipping: [ubuntu1] => (item=154)
skipping: [ubuntu2] => (item=0)
skipping: [amazon2] => (item=234)
skipping: [ubuntu2] => (item=192)
skipping: [ubuntu1] => (item=456)
skipping: [ubuntu1] => (item=7)
skipping: [ubuntu1] => (item=2)
skipping: [ubuntu1] => (item=-1)
skipping: [ubuntu2] => (item=154)
ok: [ubuntu1] => (item=55) => {
    "ansible_loop_var": "item",
    "item": 55
}
skipping: [ubuntu1] => (item=234)
skipping: [ubuntu2] => (item=456)
skipping: [ubuntu2] => (item=7)
skipping: [ubuntu2] => (item=2)
skipping: [ubuntu2] => (item=-1)
ok: [ubuntu2] => (item=55) => {
    "ansible_loop_var": "item",
    "item": 55
}
skipping: [ubuntu2] => (item=234)

TASK [Show items not between 10 and 100] *********************************************
ok: [amazon1] => (item=0) => {
    "ansible_loop_var": "item",
    "item": 0
}
ok: [amazon1] => (item=192) => {
    "ansible_loop_var": "item",
    "item": 192
}
ok: [amazon1] => (item=154) => {
    "ansible_loop_var": "item",
    "item": 154
}
ok: [amazon1] => (item=456) => {
    "ansible_loop_var": "item",
    "item": 456
}
ok: [amazon1] => (item=7) => {
    "ansible_loop_var": "item",
    "item": 7
}
ok: [amazon1] => (item=2) => {
    "ansible_loop_var": "item",
    "item": 2
}
ok: [amazon1] => (item=-1) => {
    "ansible_loop_var": "item",
    "item": -1
}
skipping: [amazon1] => (item=55)
ok: [amazon1] => (item=234) => {
    "ansible_loop_var": "item",
    "item": 234
}
ok: [amazon2] => (item=0) => {
    "ansible_loop_var": "item",
    "item": 0
}
ok: [amazon2] => (item=192) => {
    "ansible_loop_var": "item",
    "item": 192
}
ok: [amazon2] => (item=154) => {
    "ansible_loop_var": "item",
    "item": 154
}
ok: [ubuntu1] => (item=0) => {
    "ansible_loop_var": "item",
    "item": 0
}
ok: [ubuntu1] => (item=192) => {
    "ansible_loop_var": "item",
    "item": 192
}
ok: [amazon2] => (item=456) => {
    "ansible_loop_var": "item",
    "item": 456
}
ok: [ubuntu1] => (item=154) => {
    "ansible_loop_var": "item",
    "item": 154
}
ok: [ubuntu1] => (item=456) => {
    "ansible_loop_var": "item",
    "item": 456
}
ok: [amazon2] => (item=7) => {
    "ansible_loop_var": "item",
    "item": 7
}
ok: [ubuntu1] => (item=7) => {
    "ansible_loop_var": "item",
    "item": 7
}
ok: [ubuntu1] => (item=2) => {
    "ansible_loop_var": "item",
    "item": 2
}
ok: [amazon2] => (item=2) => {
    "ansible_loop_var": "item",
    "item": 2
}
ok: [amazon2] => (item=-1) => {
    "ansible_loop_var": "item",
    "item": -1
}
skipping: [amazon2] => (item=55)
ok: [ubuntu1] => (item=-1) => {
    "ansible_loop_var": "item",
    "item": -1
}
skipping: [ubuntu1] => (item=55)
ok: [ubuntu1] => (item=234) => {
    "ansible_loop_var": "item",
    "item": 234
}
ok: [amazon2] => (item=234) => {
    "ansible_loop_var": "item",
    "item": 234
}
ok: [ubuntu2] => (item=0) => {
    "ansible_loop_var": "item",
    "item": 0
}
ok: [ubuntu2] => (item=192) => {
    "ansible_loop_var": "item",
    "item": 192
}
ok: [ubuntu2] => (item=154) => {
    "ansible_loop_var": "item",
    "item": 154
}
ok: [ubuntu2] => (item=456) => {
    "ansible_loop_var": "item",
    "item": 456
}
ok: [ubuntu2] => (item=7) => {
    "ansible_loop_var": "item",
    "item": 7
}
ok: [ubuntu2] => (item=2) => {
    "ansible_loop_var": "item",
    "item": 2
}
ok: [ubuntu2] => (item=-1) => {
    "ansible_loop_var": "item",
    "item": -1
}
skipping: [ubuntu2] => (item=55)
ok: [ubuntu2] => (item=234) => {
    "ansible_loop_var": "item",
    "item": 234
}

TASK [Install Packages on Ubuntu] ****************************************************
skipping: [amazon1] => (item=git)
skipping: [amazon1] => (item=curl)
skipping: [amazon1] => (item=htop)
skipping: [amazon2] => (item=git)
skipping: [amazon2] => (item=curl)
skipping: [amazon2] => (item=htop)
ok: [ubuntu1] => (item=git)
ok: [ubuntu2] => (item=git)
ok: [ubuntu1] => (item=curl)
ok: [ubuntu2] => (item=curl)
ok: [ubuntu1] => (item=htop)
ok: [ubuntu2] => (item=htop)

TASK [Install Packages on Amazon Linux] **********************************************
skipping: [ubuntu1] => (item=git)
skipping: [ubuntu1] => (item=curl)
skipping: [ubuntu1] => (item=htop)
skipping: [ubuntu2] => (item=git)
skipping: [ubuntu2] => (item=curl)
skipping: [ubuntu2] => (item=htop)
ok: [amazon2] => (item=git)
ok: [amazon2] => (item=curl)
ok: [amazon2] => (item=htop)
changed: [amazon1] => (item=git)
ok: [amazon1] => (item=curl)
changed: [amazon1] => (item=htop)

TASK [Print users] *******************************************************************
changed: [ubuntu2]
changed: [ubuntu1]
changed: [amazon2]
changed: [amazon1]

TASK [Is there claud] ****************************************************************
skipping: [amazon1]
skipping: [amazon2]
ok: [ubuntu1] => {
    "msg": "There is no claud"
}
ok: [ubuntu2] => {
    "msg": "There is no claud"
}
```

## 코드 해설

```
- name: "Print users"
    command: "cut -d: -f1 /etc/passwd"
    register: users

  - name: "Is there claud"
    debug:
      msg: "There is no claud"
    when: users.stdout.find('claud') == -1
```

`cut -d: -f1 /etc/passwd`를 명령하면 아래와 같이 사용자명이 출력됩니다.   
![image](https://user-images.githubusercontent.com/43658658/160265210-e46842a9-6b58-4ac3-b12c-aef6c8b0eac2.png)

이것을 `register` 속성을 통해 `users` 변수에 등록합니다.

그리고 `when: users.stdout.find('claud') == -1`을 통해 `users` 변수의 `stdout(출력)`에서 `claud`라는 유저를 `find(찾아)`했을 때 `-1`로 존재하지 않으면, `There is no claud` 메시지를 출력하라는 의미입니다.

