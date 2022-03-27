# 앤서블 상세(facts)

=> [앤서블 상세에 대한 공식 문서 설명](https://docs.ansible.com/ansible/latest/user_guide/playbooks_vars_facts.html#ansible-facts)

`gather_facts: false` : 상세를 모으지 않도록 하는 설정. 대규모 시스템 관리 시 성능 향상. 테스트 환경에서 빠른 실행.   
- 각 플레이에는 위 옵션을 주고, `debug` 모듈을 통해 `ansible_facts`를 출력해서 상세를 확인하는 트릭이 있습니다.

``` yaml
---

- name: Prepare Amazon Linux
  hosts: amazon
  become: true
  gather_facts: false
  tasks:
  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
  - name: "Install python on Amazon Linux"
    yum:
      name: "python3"
      state: "present"

- name: Prepare Ubuntu
  hosts: ubuntu
  become: true
  gather_facts: false
  tasks:
  - name: "Install python on Ubuntu"
    apt:
      name: "python3"
      state: "present"
      update_cache: true

- name: Debug
  hosts: all
  become: true
  tasks:
  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
  - name: "Debug Ansible facts"
    debug:
      var: ansible_facts
```
