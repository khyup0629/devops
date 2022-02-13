# 볼륨 마운트

컨테이너의 데이터를 영구적으로 보존하기 위해서는? : **볼륨 마운트**

```
docker run -d --name db -v /dbdata:/var/lib/mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=pass mysql
```   
- `-v`옵션을 이용해 **Docker HOST**에 디스크(`/dbdata`)를 만들어 그 안에 컨테이너 속 `/var/lib/mysql`의 데이터를 저장

```
-v <host path>:<container mount path>
-v <host path>:<container mount path>:<read write mode>
-v <container mount path>
```

```
docker run -d -v /dbdata:/var/lib/mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=pass mysql
docker run -d -v /webdata:/var/www/html:ro httpd
docker run -d -v /var/lib/mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=pass mysql
```

> <h3>mysql DB data 영구 보존하기 - 실습1</h3>

컨테이너의 데이터를 Docker Host의 디스크에 마운트 시켜보겠습니다.   
```
(컨테이너) -----------> (Docker Host)   
/var/lib/mysql          /dbdata   
```

db라는 이름의 mysql 컨테이너를 생성하고 `/var/lib/mysql` 경로의 data를 Docker Host의 `/dbdata`에 마운트   
(백그라운드 실행, 루트 패스워드 : pass)   
```
docker run -d -v /dbdata:/var/lib/mysql --name db -e MYSQL_ROOT_PASSWORD=pass mysql
```

이제 mysql로 접속해 데이터베이스를 생성해보겠습니다.      
```
docker exec -it db /bin/bash
mysql -u root -p
Enter Password: pass
> create database bllu;
> show databases;
> exit
exit
```

`bllu`라는 이름의 데이터베이스를 생성했습니다.   
그럼 Docker Host의 /dbdata 아래에 `bllu`라는 디렉토리가 생깁니다.   
```
cd /dbdata
ls
```   
![image](https://user-images.githubusercontent.com/43658658/153747861-fe759797-180a-47c9-8e16-703c8dea0923.png)

db 컨테이너를 삭제하면 컨테이너의 내용은 삭제됩니다.   
하지만 `/dbdata/bllu`는 영구적으로 보존됩니다.   
```
docker rm -f db
ls
```   
![image](https://user-images.githubusercontent.com/43658658/153747928-fa10492c-044a-4815-9d98-164dfc82a553.png)

> <h3>mysql DB data 영구 보존하기 - 실습2</h3>

이번엔 Docker Host의 디스크를 지정하지 않고 db 컨테이너를 생성해봅니다.   
```
docker run -d -v /var/lib/mysql --name db -e MYSQL_ROOT_PASSWORD=pass mysql
```

`/var/lib/mysql`이 어디에 마운트 되었는지는 `inspect` 명령어를 통해 알 수 있습니다.   
```
docker inspect db
```   
![image](https://user-images.githubusercontent.com/43658658/153748085-bb2227f6-82cd-4d27-b463-3b4778772779.png)   
- `Mounts`의 `Source`를 보면 `/var/lib/docker/volumes/UUID/_data`에 저장된다는 것을 확인할 수 있습니다.

mysql에 아까와 동일하게 데이터베이스를 생성합니다.   
```
docker exec -it db /bin/bash
mysql -u root -p
Enter Password: pass
> create database bllu;
> show databases;
> exit
exit
```

실제로 `cd`를 통해 확인해봅시다.   
```
cd /var/lib/docker/volumes/3316384babbdf3d299165216dbea98394490ba1fa39824751768d64cfe9163ca/_data
ls
```   
![image](https://user-images.githubusercontent.com/43658658/153748252-c8b9fca8-e404-4da4-b267-fa1a0a4dee39.png)   
- 그 밖에도 **실습1**에서 `/dbdata`에 저장된 내용과 동일한 것을 확인할 수 있습니다. 

> <h3>사용하지 않는 볼륨 삭제</h3>

컨테이너 볼륨은 컨테이너를 삭제해도 남아있습니다.   

컨테이너 볼륨 리스트를 확인하는 명령어입니다.   
```
docker volume ls
```   
- UUID 리스트가 나옵니다.

컨테이너 볼륨을 삭제하는 명령어입니다.   
```
docker volume rm <컨테이너 볼륨 UUID>
```

> <h3>웹데이터 readonly 서비스로 컨테이너에 지원</h3>

```
(Docker Host) --------------> (컨테이너)
/webdata/index.html           /usr/share/nginx/html
```

먼저 Docker Host에 `/webdata`를 만들고 안에 `index.html`을 만듭니다.   
```
mkdir /webdata
cd /webdata
echo "<h1>Hello World</h1>" > index.html
```

이제 nginx 컨테이너의 `/usr/share/nginx/html`을 `/webdata`에 **readonly** 방식으로 마운트하여 실행합니다.   
```
docker run -d -v /webdata:/usr/share/nginx/html:ro -p 80:80 --name web nginx
```

그리고 `curl` 명령을 이용해 `localhost:80`을 확인하면 `index.html`의 내용이 출력됩니다.   
```
curl localhost:80
```   
![image](https://user-images.githubusercontent.com/43658658/153749042-0db23efd-4495-41c5-9b26-53627921921e.png)

## 컨테이너 끼리 데이터 공유

두 개의 컨테이너가 Docker Host의 같은 디스크를 바라보게 하면 데이터를 공유할 수 있습니다.

```
web content generator ---------------> /webdata/index.html -----------> web server
(df -h 명령이 10초 마다 실행되어 /webdata/index.html에 저장)              /webdata:/usr/share/nginx/html
```

먼저 실습용 디렉토리를 하나 만들고, 그 안에 `df.sh` 스크립트 파일을 만듭니다.   
```
mkdir lab8
cd lab8
vim df.sh
```

`<df.sh>`   
``` bash
#!/bin/bash
mkdir -p /webdata
while true
do
  df -h > /webdata/index.html
  sleep 10
done
```

`dockerfile`을 만듭니다.   
```
vim dockerfile
```

`<dockerfile>`   
```
FROM ubuntu:18.04
ADD df.sh /bin/df.sh
RUN chmod +x /bin/df.sh
ENTRYPOINT ["/bin/df.sh"]  
```   
- **ADD** : df.sh 파일을 컨테이너 속 /bin/df.sh에 넣습니다.
- **RUN** : 컨테이너가 빌드될 때 /bin/df.sh 파일에 대한 실행(x) 권한을 부여합니다.
- **ENTRYPOINT** : CMD와 같은 역할을 하는데 docker 명령어 뒤에 파라미터에 상관없이 무조건 컨테이너가 실행될 때 /bin/df.sh 명령을 하도록 합니다.

이제 컨테이너를 빌드합니다.   
```
docker build -t df .
```

만들어진 컨테이너 이미지로 df라는 컨테이너를 실행하는데, Docker Host의 `/webdata`에 컨테이너의 `/webdata`를 마운트합니다.
```
docker run -d -v /webdata:/webdata --name df smlinux/df
```

`cat` 명령으로 확인해보면 Docker Host의 `/webdata/index.html`에는 `df -h`가 실행된 결과가 나타나는 것을 확인할 수 있습니다.   
```
cat /webdata/index.html
```   
![image](https://user-images.githubusercontent.com/43658658/153749935-0c828af0-8629-4836-a6f0-d226b97e57fd.png)

이제 웹 서버를 만들고 컨테이너가 Docker Host의 `/webdata`를 공유합니다.   
```
docker run -d -v /webdata:/usr/share/nginx/html:ro --name web -p 80:80 nginx   # 웹 데이터 readonly 서비스로 지원
```

`curl` 명령어를 이용해 `localhost:80`로 접속해 웹 페이지를 확인합니다.   
```
curl localhost:80
```   
![image](https://user-images.githubusercontent.com/43658658/153750132-dc0dad0d-cd75-46eb-a28f-b2ffce90f453.png)



