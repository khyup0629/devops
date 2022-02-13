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

> <h3>mysql DB data 영구 보존하기 - 실습</h3>

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


## 컨테이너 끼리 데이터 공유

web content generator -> /webdata/index.html -> web server

```
docker run -d -v /webdata:/webdata --name df smlinux/df
docker run -d -v /webdata:/usr/share/nginx/html:ro ubuntu   # 웹 데이터 readonly 서비스로 지원
```




