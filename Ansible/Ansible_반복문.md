# 앤서블 반복문

`loop` 문법은 앤서블 2.5 버전부터 새로 나온 반복문법인데, 기존의 `with` 문법을 완벽히 대체하진 않고 있어 서로 공존하고 있지만,

추후를 고려해 `loop`로 반복문을 작성하는 것이 좋습니다.

## with_itmes 문법

`with` 문법의 사용법부터 살펴보겠습니다.

``` yaml
# playbook.yaml
---

- name: Example
  hosts: ubuntu
  become: true
  tasks:
  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/group_module.html
  - name: "Create groups"
    group:
      name: "{{ item }}"
      state: "present"
    with_items:
    - backend
    - frontend
    - devops
```

`{{ item }}`은 `jinja2` 문법으로 `with_items`의 항목들을 순서대로 조회한다는 의미입니다.

`ubuntu` 서버로 접근해 그룹 목록을 확인해보면 3개의 그룹이 추가된 것을 확인할 수 있습니다.   

```
ssh ubuntu@ec2-13-124-77-230.ap-northeast-2.compute.amazonaws.com
```

```
cat /etc/group
```

![image](https://user-images.githubusercontent.com/43658658/159863461-d75687fa-d25e-44a6-a506-3b597447a098.png)

## loop 

``` yaml
# playbook.yaml
---

- name: Example
  hosts: ubuntu
  become: true
  vars:
    tags:
      Name: "Debug"
      Environment: "Test"
      Owner: "posquit0"
    users:
    - name: john
      shell: /bin/bash
    - name: alice
      shell: /bin/sh
    - name: claud
      shell: /bin/bash
    - name: henry
      shell: /bin/sh
    - name: jeremy
      shell: /bin/bash
    - name: may
      shell: /bin/sh
  tasks:
  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/group_module.html
  - name: "Create groups"
    group:
      name: "{{ item }}"
      state: "present"
    with_items:
    - backend
    - frontend
    - devops

  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
  # - name: "Create a user"
  #   user:
  #     name: "{{ item }}"
  #     comment: "FastCampus DevOps"
  #     state: "present"
  #   loop:
  #   - john
  #   - alice
  #   - claud
  #   - henry
  #   - jeremy
  #   - may

  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
  - name: "Create a user"
    user:
      name: "{{ item.name }}"
      shell: "{{ item.shell }}"
      comment: "FastCampus DevOps"
      state: "present"
    loop: "{{ users }}"

  - name: "Debug data"
    debug:
      msg: "{{ item.key }}: {{ item.value }}"
    loop: "{{ tags | dict2items }}"
```

변수로 `users`를 생성해주고 `loop`는 `users`를 참조합니다. `item`은 `loop`의 `users`를 참조하도록 만듭니다.

`tags` 변수는 `users` 변수와는 다르게 하나의 딕셔너리로 이루어져 있습니다.   
이 하나의 딕셔너리 안의 key-value를 하나씩 참조하고 싶은 경우,   
`loop`에서 `{{ tags | dict2items }}`를 통해 딕셔너리를 `item`으로 바꿔준 뒤,   
`item.key`, `item.value`로 key-value를 하나씩 조회할 수 있습니다.

`debug` 모듈은 CLI output으로 메시지의 값을 출력합니다.   
![image](https://user-images.githubusercontent.com/43658658/159862940-18eb7cd8-17c4-4f98-8d23-1520f49b9bfc.png)


