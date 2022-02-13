# 컨테이너 네트워크

## docker0 (172.17.0.1)

- virtual ethernet bridge 네트워크 : `172.17.0.0/16`
- **G/W** 역할을 합니다.
- L2 통신기반
- container 생성 시 `veth` 인터페이스를 생성합니다(Sandbox).
  - ex) 하나 생성하면 `veth0 - 172.17.0.2`, 또 하나 생성하면 `veth1 - 172.17.0.3` 
- 모든 컨테이너는 외부 통신을 **docker0**로 진행합니다.
- container 실행 시 `172.17.X.Y`로 IP 주소를 할당합니다.

현재 존재하는 인터페이스와 IP 주소를 확인하는 명령어   
```
ip addr
```   
![image](https://user-images.githubusercontent.com/43658658/153750719-f1ced561-d31a-4c98-9a64-c4817f0a6caa.png)

bridge 인터페이스의 리스트를 보는 명령어   
```
brctl show
```   
![image](https://user-images.githubusercontent.com/43658658/153751532-3b044f81-aeff-4e40-9695-c930905a8b7f.png)

## 포트 포워딩

- container 포트를 외부로 노출시켜 외부 연결을 허용합니다.
- `-p hostPort:containerPort`를 통해 포트포워딩 규칙을 설정합니다.
- **서로 다른 컨테이너**가 Docker Host의 **동일한 포트**를 통해 포트포워딩 할 수 없습니다.
  * ex) `-p 80:80`과 `-p 80:8080`은 공존할 수 없습니다. 

아래의 명령어를 통해 Docker Host 전체의 iptables 규칙을 볼 수 있습니다.
```
iptables -t nat -L -n -v
```   
![image](https://user-images.githubusercontent.com/43658658/153751917-269963b8-1e24-4a33-83b0-9bd07876810c.png)

> <h3>-p 80:80</h3>

`-p <호스트포트>:<컨테이너포트>` 형식으로 호스트와 컨테이너 포트를 설정해 포트포워딩합니다.   
```
docker run -d --name web -p 80:80 nginx
```   
![image](https://user-images.githubusercontent.com/43658658/153752061-5620e7aa-f1f6-4b2a-92f8-dd9f8c4239d3.png)

> <h3>-p random:80</h3>

`-p` 옵션에 컨테이너 포트만 입력해주게 되면 호스트 포트는 무작위로 할당됩니다.   
```
docker run -d --name web -p 80 nginx
```   
![image](https://user-images.githubusercontent.com/43658658/153751982-aba61506-91f4-4b3d-9416-d77059ec6dc3.png)   

> <h3>-P</h3>

`-P` 옵션은 컨테이너를 빌드할 때 **dockerfile** 내의 `EXPOSE`의 포트 수만큼 컨테이너 포트를 무작위 호스트 포트에 연결합니다.   
```
docker run -d --name web -P nginx
```   
![image](https://user-images.githubusercontent.com/43658658/153752176-268cb90e-6493-4d09-885f-763b4f2ae50a.png)   
- `nginx`의 dockerfile은 `EXPOSE`에 80번 포트 하나만 노출되어 있어 80번 포트만 무작위 호스트 포트와 포트포워딩 설정이 되었습니다.

## 컨테이너에 정적 IP 부여하기

컨테이너 IP가 `172.17.0.0/16` 내에서 DHCP 방식으로 생성되지 않고, **정적 IP를 할당**하고 싶다면,

기존의 `172.17.0.0/16` 대역의 네트워크를 그대로 두고,   

**user-defined bridge network**를 새로 생성하면 됩니다.

`docker network ls` 명령은 현재 Docker HOST 내 **Network** 리스트를 나타냅니다.   
```
docker network ls
```   
![image](https://user-images.githubusercontent.com/43658658/153752284-92b44711-d251-474f-a36d-8a70f0bc9b75.png)   
- 기본으로 3개의 네트워크가 있는데, 그 중 `bridge` 네트워크가 **docker0**가 있는 네트워크입니다.

**user-defined bridge network**를 생성합니다.   
```
docker network create --driver bridge --subnet 192.168.100.0/24 --gateway 192.168.100.254 mynet
```   
- `--driver bridge`는 디폴트 값
- `--gateway`를 주지 않게 되면 디폴트로 `192.168.100.1` 식으로 서브넷의 네트워크를 따라 1번 호스트로 생성됩니다.

다시 Docker 네트워크의 리스트를 확인합니다.   
```
docker network ls
```   
![image](https://user-images.githubusercontent.com/43658658/153752372-77a6d291-fcb3-44f7-81c0-2201ee6bcd73.png)   
- `mynet`이라는 bridge 유형의 네트워크가 만들어졌습니다.

`inspect` 명령을 통해 네트워크 설정을 확인할 수 있습니다.   
```
docker inspect mynet
```   
![image](https://user-images.githubusercontent.com/43658658/153752425-a4b6010d-fc2a-4bfb-ae89-7fb71e042412.png)

```
docker run -it --name c1 --net mynet --ip 192.168.100.100 busybox
/ # ip addr
```   
![image](https://user-images.githubusercontent.com/43658658/153752739-a69a6bba-3709-45c6-8bfa-0e93cfc79cf4.png)

## 컨테이너 끼리 통신

```
eth0(172.16.0.202) ------> docker0(172.17.0.1) ------> wordpress(172.17.0.2:80) ------> mysql(172.17.0.3)
외부에서 80번 포트로 접속    80번 포트로 포트포워딩       웹 서버                           웹 서버의 데이터를 저장
```

먼저 **mysql 컨테이너**를 실행합니다.
```
docker run -d --name mysql -v /dbdata:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=wordpress -e MYSQL_PASSWORD=wordpress mysql:5.7
```   
- `MYSQL_PASSWORD=wordpress` : 워드프레스에서 접속하기 위한 일반 사용자 비밀번호 설정.

**wordpress 컨테이너**를 실행합니다.   
```
docker run -d --name wordpress --link mysql:mysql -p 80:80 -e WORDPRESS_DB_PASSWORD=wordpress wordpress:4
```   
- `--link <연동할 컨테이너 이름>:<앨리아스>` : 현재 실행할 컨테이너를 mysql과 연동합니다.
- `-e WORDPRESS_DB_PASSWORD=wordpress` : mysql과 연동될 때 사용할 패스워드 할당.

웹 브라우저를 통해 `172.16.0.202:80`로 접속합니다.   
![image](https://user-images.githubusercontent.com/43658658/153753313-3e908158-2746-49a1-a274-79b21c3bc7f5.png)   
- **한국어**로 선택합니다.

정보를 입력하고 Wordpress를 설치합니다.   
![image](https://user-images.githubusercontent.com/43658658/153753362-915f8948-690d-4f15-8f63-8ec208ef03d4.png)

Wordpress가 설치완료 되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/153753503-898628d7-badc-45dd-ab6f-d5af148c35a7.png)

Docker Host의 `/dbdata`의 리스트를 보면 `wordpress`가 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/153753587-663d72bb-4e7d-4225-98f5-26fe156f9e66.png)

