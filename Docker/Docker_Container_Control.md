# 컨테이너 관리

## 컨테이너 이미지 관리

```
docker search [옵션] <이미지이름:태그명>
docker pull [옵션] <이미지이름:태그명>
docker images
docker inspect [옵션] <이미지이름:태그명>     // 컨테이너 이미지의 메타
docker rmi [옵션] <이미지이름:태그명>
```

![image](https://user-images.githubusercontent.com/43658658/152710791-1a38d502-add4-43ec-9755-8a04f6458588.png)   
- `docker images --no-trunc` : 이미지 ID를 풀네임으로 표시

![image](https://user-images.githubusercontent.com/43658658/152710836-4b8fa6c3-c40e-4c04-a93e-1d51b60b06f6.png)   
- JSON 형식으로 출력됩니다.



## 컨테이너 실행 라이프 사이클

```
docker create [옵션] <이미지이름:태그명>     // 이미지를 컨테이너로 만듭니다. 이때 디스크에 존재합니다.
docker start [옵션] <컨테이너이름>          // 컨테이너를 실행시켜 올립니다.
docker run [옵션] <이미지이름:태그명>     // 컨테이너 생성/실행(create + start)
docker ps         // 현재 실행중인 컨테이너 리스트
docker inspect [옵션] <컨테이너이름>      // 현재 실행중인 컨테이너의 메타데이터
docker stop [옵션] <컨테이너이름>         // 컨테이너 실행 중지
docker rm [옵션] <컨테이너이름>           // 컨테이너 디스크에서 삭제
```

![image](https://user-images.githubusercontent.com/43658658/152711261-01ba36cd-0d02-4152-b007-85f61b39b41b.png)   

![image](https://user-images.githubusercontent.com/43658658/152711301-bdf99e3b-2b05-457d-8a3e-fc80f3369234.png)   
- `docker inspect`를 통해 IP주소 등 다양한 정보를 알 수 있습니다.

![image](https://user-images.githubusercontent.com/43658658/152711476-95dfa879-15c0-46fe-9a5d-9617ff5a8d7a.png)   
- `--format` 옵션을 이용해 특정 정보만 출력되도록 할 수도 있습니다.

![image](https://user-images.githubusercontent.com/43658658/152711618-c5e3f15a-e7d1-46cb-ba66-f7d6611d6321.png)   
- 웹 서버가 동작 중인 것을 확인할 수 있습니다.

## 실행중인 컨테이너 관리

```
docker attach [옵션] <컨테이너이름>     // 실행중인 컨테이너에 포그라운드로 연결
docker exec [옵션] <컨테이너이름> /bin/bash     // 동작 중인 컨테이너에 명령어 추가 실행
docker top [옵션] <컨테이너이름>      // 컨테이너 내에서 동작되는 프로세스 확인
docker logs [옵션] <컨테이너이름>     // 컨테이너가 생성한 로그 확인
```

```
docker logs webserver
docker logs -f webserver
```   
![image](https://user-images.githubusercontent.com/43658658/152711727-93423248-90b1-4ea7-b346-46a89544d9e2.png)   
- `-f` 옵션은 로그를 포그라운드로 실행해서 실시간으로 로그 정보를 볼 수 있습니다.

```
docker top webserver
```   
![image](https://user-images.githubusercontent.com/43658658/152711822-075196a1-f60f-4db5-be97-e1a974d5f7a7.png)   
- `docker top` : 컨테이너 내부에서 실행 중인 프로세스를 확인할 수 있습니다.

컨테이너로 들어가 bash 셀 터미널을 띄웁니다.   
```
docker inspect --format '{{.NetworkSettings.IPAddress}}' webserver
alias cip="docker inspect --format '{{.NetworkSettings.IPAddress}}' webserver"    // 명령어가 너무 길기 때문에 앨리아스를 지정할 수도 있습니다.
```   
![image](https://user-images.githubusercontent.com/43658658/152713294-4aed25a3-b22e-40e7-bcf2-4d1cb6c29950.png)   
- `/usr/share/nginx/html/` 경로에 웹 페이지들이 있습니다.

`exit`를 통해 컨테이너에서 빠져나올 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/152714139-515e2f52-c64b-47b7-af6d-971d170bd945.png)









