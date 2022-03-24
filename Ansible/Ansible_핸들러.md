# 앤서블 핸들러

- `핸들러` : 이벤트 기반으로 동작하는 Task
- Task끼리 의존성을 가지도록 설정할 수 있습니다.
- 예를 들어, 특정 Task 안에 `notify`라는 파라미터를 통해 `handlers` 이름을 명시하면, 특정 Task가 실행됐을 때 변경사항이 존재하면, `notify` 안의 핸들러에 정의된 Task가 실행됩니다.

``` yaml
notify:
- Restart Nginx

handlers:
- name: Restart Nginx
  service:
    name: nginx
    state: restarted
```

이런 핸들러는 nginx, apache 등등 config가 수정되고 서비스를 재시작해야 할 때 유용하게 사용될 수 있습니다.   
config 파일과 관련한 `copy` 모듈을 실행할 때 변경사항이 존재하면 `notify`를 통해 `Restart Nginx`라는 이름의 핸들러가 실행될 수 있도록 합니다.   
(`Restart Nginx` 핸들러는 남아있는 모든 작업이 끝나고 실행됩니다)   
그리고 `Restart Nginx`라는 이름의 핸들러를 정의합니다.   


``` yaml
# example.yaml
---

- name: Example
  hosts: ubuntu
  become: true
  tasks:
  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
  - name: "Create a user"
    user: "name=fastcampus shell=/bin/bash"

  - name: "Hello World"
    command: "echo 'Hello World!'"

  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html
  - name: "Add DNS server to resolv.conf"
    lineinfile:
      path: /etc/resolv.conf
      line: 'nameserver 8.8.8.8'

  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html
  - name: "Install Nginx"
    apt:
      name: nginx
      state: present
      update_cache: true

  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/posix/synchronize_module.html
  - name: "Upload web directory"
    synchronize:
      src: files/html/
      dest: /var/www/html
      archive: true
      checksum: true
      recursive: true
      delete: true

  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html
  - name: "Copy nginx configuration file"
    copy:
      src: files/default
      dest: /etc/nginx/sites-enabled/default
      owner: "{{ ansible_user }}"
      group: "{{ ansible_user }}"
      mode: '0644'
    notify:
    - Restart Nginx

  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html
  - name: "Ensure nginx service started"
    service:
      name: nginx
      state: started

  handlers:
  - name: Restart Nginx
    service:
      name: nginx
      state: restarted
```

위 플레이북을 실행할 때, `./files/default` 파일에 변경사항이 일어나면 `Restart Nginx`가 실행됩니다.   
그리고 모든 작업이 끝나고 제일 마지막에 핸들러가 실행됩니다.   
![image](https://user-images.githubusercontent.com/43658658/159850687-c892f8a4-a16d-4b49-84c5-f7ea277cd758.png)

반면에 변경사항이 없다면, 핸들러도 실행되지 않는 모습을 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/159850752-668ed421-9c25-423d-9f4d-0217acb42742.png)


## 핸들러 사용 시 유의점

1. 플레이 내에서 같은 이벤트를 여러 번 호출하더라도 동일한 핸들러는 한 번만 실행됩니다.
2. 모든 핸들러는 플레이 내에 모든 작업이 완료된 후에 실행됩니다.
3. 핸들러는 이벤트 호출 순서에 따라 실행되는 것이 아니라 핸들러 정의 순서에 따라 실행됩니다.


