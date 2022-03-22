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

아래의 명령으로 ubuntu 호스트에 nginx가 잘 설치되었는지 확인해봅니다.

```
ansible -i inventory ubuntu -m command -a "curl localhost"
```

```
ubuntu2 | CHANGED | rc=0 >>
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   199k      0 --:--:-- --:--:-- --:--:--  199k
ubuntu1 | CHANGED | rc=0 >>
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   199k      0 --:--:-- --:--:-- --:--:--  199k
```

마찬가지로 `amazon linux`에 대해서도 nginx가 잘 설치되었는지 확인해봅시다.

```
ansible -i inventory amazon -m command -a "curl localhost"
```

```
[WARNING]: Platform linux on host amazon2 is using the discovered Python interpreter
at /usr/bin/python3.7, but future installation of another Python interpreter could
change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.12/reference_appendices/interpreter_discovery.html for more information.
amazon2 | CHANGED | rc=0 >>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
    <head>
        <title>Test Page for the Nginx HTTP Server on Amazon Linux</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <style type="text/css">
            /*<![CDATA[*/
            body {
                background-color: #fff;
                color: #000;
                font-size: 0.9em;
                font-family: sans-serif,helvetica;
                margin: 0;
                padding: 0;
            }
            :link {
                color: #c00;
            }
            :visited {
                color: #c00;
            }
            a:hover {
                color: #f50;
            }
            h1 {
                text-align: center;
                margin: 0;
                padding: 0.6em 2em 0.4em;
                background-color: #294172;
                color: #fff;
                font-weight: normal;
                font-size: 1.75em;
                border-bottom: 2px solid #000;
            }
            h1 strong {
                font-weight: bold;
                font-size: 1.5em;
            }
            h2 {
                text-align: center;
                background-color: #3C6EB4;
                font-size: 1.1em;
                font-weight: bold;
                color: #fff;
                margin: 0;
                padding: 0.5em;
                border-bottom: 2px solid #294172;
            }
            hr {
                display: none;
            }
            .content {
                padding: 1em 5em;
            }
            .alert {
                border: 2px solid #000;
            }

            img {
                border: 2px solid #fff;
                padding: 2px;
                margin: 2px;
            }
            a:hover img {
                border: 2px solid #294172;
            }
            .logos {
                margin: 1em;
                text-align: center;
            }
            /*]]>*/
        </style>
    </head>

    <body>
        <h1>Welcome to <strong>nginx</strong> on Amazon Linux!</h1>

        <div class="content">
            <p>This page is used to test the proper operation of the
            <strong>nginx</strong> HTTP server after it has been
            installed. If you can read this page, it means that the
            web server installed at this site is working
            properly.</p>

            <div class="alert">
                <h2>Website Administrator</h2>
                <div class="content">
                    <p>This is the default <tt>index.html</tt> page that
                    is distributed with <strong>nginx</strong> on
                     Amazon Linux.  It is located in
                    <tt>/usr/share/nginx/html</tt>.</p>

                    <p>You should now put your content in a location of
                    your choice and edit the <tt>root</tt> configuration
                    directive in the <strong>nginx</strong>
                    configuration file
                    <tt>/etc/nginx/nginx.conf</tt>.</p>

                </div>
            </div>

            <div class="logos">
                <a href="http://nginx.net/"><img
                    src="nginx-logo.png"
                    alt="[ Powered by nginx ]"
                    width="121" height="32" /></a>
            </div>
        </div>
    </body>
</html>  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3520  100  3520    0     0  1108k      0 --:--:-- --:--:-- --:--:-- 1718k
[WARNING]: Platform linux on host amazon1 is using the discovered Python interpreter
at /usr/bin/python3.7, but future installation of another Python interpreter could
change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.12/reference_appendices/interpreter_discovery.html for more information.
amazon1 | CHANGED | rc=0 >>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
    <head>
        <title>Test Page for the Nginx HTTP Server on Amazon Linux</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <style type="text/css">
            /*<![CDATA[*/
            body {
                background-color: #fff;
                color: #000;
                font-size: 0.9em;
                font-family: sans-serif,helvetica;
                margin: 0;
                padding: 0;
            }
            :link {
                color: #c00;
            }
            :visited {
                color: #c00;
            }
            a:hover {
                color: #f50;
            }
            h1 {
                text-align: center;
                margin: 0;
                padding: 0.6em 2em 0.4em;
                background-color: #294172;
                color: #fff;
                font-weight: normal;
                font-size: 1.75em;
                border-bottom: 2px solid #000;
            }
            h1 strong {
                font-weight: bold;
                font-size: 1.5em;
            }
            h2 {
                text-align: center;
                background-color: #3C6EB4;
                font-size: 1.1em;
                font-weight: bold;
                color: #fff;
                margin: 0;
                padding: 0.5em;
                border-bottom: 2px solid #294172;
            }
            hr {
                display: none;
            }
            .content {
                padding: 1em 5em;
            }
            .alert {
                border: 2px solid #000;
            }

            img {
                border: 2px solid #fff;
                padding: 2px;
                margin: 2px;
            }
            a:hover img {
                border: 2px solid #294172;
            }
            .logos {
                margin: 1em;
                text-align: center;
            }
            /*]]>*/
        </style>
    </head>

    <body>
        <h1>Welcome to <strong>nginx</strong> on Amazon Linux!</h1>

        <div class="content">
            <p>This page is used to test the proper operation of the
            <strong>nginx</strong> HTTP server after it has been
            installed. If you can read this page, it means that the
            web server installed at this site is working
            properly.</p>

            <div class="alert">
                <h2>Website Administrator</h2>
                <div class="content">
                    <p>This is the default <tt>index.html</tt> page that
                    is distributed with <strong>nginx</strong> on
                     Amazon Linux.  It is located in
                    <tt>/usr/share/nginx/html</tt>.</p>

                    <p>You should now put your content in a location of
                    your choice and edit the <tt>root</tt> configuration
                    directive in the <strong>nginx</strong>
                    configuration file
                    <tt>/etc/nginx/nginx.conf</tt>.</p>

                </div>
            </div>

            <div class="logos">
                <a href="http://nginx.net/"><img
                    src="nginx-logo.png"
                    alt="[ Powered by nginx ]"
                    width="121" height="32" /></a>
            </div>
        </div>
    </body>
</html>  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3520  100  3520    0     0  1117k      0 --:--:-- --:--:-- --:--:-- 1718k
```

여기서 앤서블의 장점인 `멱등성`을 확인할 수 있습니다.

같은 플레이북을 한 번 더 실행해도 아무런 이슈 발생 없이 동일한 결과가 나타납니다.

=> `command` 모듈의 경우 기본적으로 멱등성을 보장하지 않기 때문에 몇 가지 트릭이 존재합니다.

## nginx 제거 플레이북

``` yaml
# uninstall-nginx.yaml
- name: Uninstall Nginx on Ubuntu
  hosts: ubuntu
  become: true
  tasks:
  - name: "Ensure nginx service stopped"
    service:
      name: nginx
      state: stopped

  - name: "Uninstall Nginx"
    apt:
      name: nginx
      state: absent

- name: Uninstall Nginx on Amazon Linux
  hosts: amazon
  become: true
  tasks:
  - name: "Ensure nginx service stopped"
    service:
      name: nginx
      state: stopped

  - name: "Uninstall Nginx"
    yum:
      name: nginx
      state: absent

  - name: "Disable Nginx repository provided by Amazon"
    command: "amazon-linux-extras disable nginx1"
```
