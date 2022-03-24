# 앤서블 모듈

앤서블에는 빌트인 모듈, 사용자 정의 모듈 등 다양한 모듈이 있습니다.

이러한 모듈은 앤서블 공식 문서를 통해 확인해 볼 수 있습니다.

=> [앤서블 모듈 공식 문서 - Collection Index](https://docs.ansible.com/ansible/latest/collections/index.html)

사용하고자 하는 모듈을 클릭해 들어가면 해당 모듈의 파라미터에 대한 설명, 사용 예제들을 살펴볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/159843498-95d74488-fcab-4c45-b6c0-f6c36b2c29e7.png)   
![image](https://user-images.githubusercontent.com/43658658/159843526-f3d0ab6c-a7c5-4333-9cb6-78a288c40e60.png)

``` yaml
# example.yaml
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

  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html
  - name: "Ensure nginx service started"
    service:
      name: nginx
      state: started
```

모듈의 파라미터를 입력하는 방식에는 두 가지가 있습니다.   

```
1. 첫 번째 방식
user: "name=fastcampus shell=/bin/bash"
```

```
2. 두 번째 방식
user:
  name: fastcampus
  shell: /bin/bash
```

#### 모듈 해설

- `user` : 유저를 생성하는 모듈
- `lineinfile` : 명시된 `path`에 `line`에 대한 내용이 없으면 추가, 있으면 생략
- `synchronize` : `src`에 명시된 로컬 경로와 `dest`에 명시된 원격 경로를 서로 동기화
