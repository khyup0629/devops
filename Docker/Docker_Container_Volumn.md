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

(컨테이너) -----------> (Docker Host)   
/var/lib/mysql          /dbdata   

db라는 이름의 mysql 컨테이너를 생성하고 `/var/lib/mysql` 경로의 data를 Docker Host의 `/dbdata`에 마운트   
(백그라운드 실행, 루트 패스워드 : pass)   
```
docker run -d -v /dbdata:/var/lib/mysql --name db -e MYSQL_ROOT_PASSWORD=pass mysql
```


## 컨테이너 끼리 데이터 공유

web content generator -> /webdata/index.html -> web server

```
docker run -d -v /webdata:/webdata --name df smlinux/df
docker run -d -v /webdata:/usr/share/nginx/html:ro ubuntu   # 웹 데이터 readonly 서비스로 지원
```




