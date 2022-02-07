# 컨테이너 관리

## 컨테이너 이미지 관리

```
docker search [옵션] <이미지이름:태그명>
docker pull [옵션] <이미지이름:태그명>
docker images
docker inspect [옵션] <이미지이름:태그명>
docker rmi [옵션] <이미지이름:태그명>
```

## 컨테이너 실행 라이프 사이클

```
docker create [옵션] <이미지이름:태그명>     // 이미지를 컨테이너로 만듭니다. 이때 디스크에 존재합니다.
docker start [옵션] <컨테이너이름>          // 컨테이너를 실행시켜 올립니다.
docker run [옵션] <이미지이름:태그명>     // 컨테이너 생성/실행
docker ps         // 현재 실행중인 컨테이너 리스트
docker inspect [옵션] <컨테이너이름>      // 현재 실행중인 컨테이너의 메타데이터
docker stop [옵션] <컨테이너이름>         // 컨테이너 실행 중지
docker rm [옵션] <컨테이너이름>           // 컨테이너 디스크에서 삭제
```

## 실행중인 컨테이너 관리

```
docker attach [옵션] <컨테이너이름>     // 실행중인 컨테이너에 포그라운드로 연결
docker exec webserver /bin/bash     // 동작 중인 컨테이너에 명령어 추가 실행
docker top [옵션] <컨테이너이름>      // 컨테이너 내에서 동작되는 프로세스 확인
docker logs [옵션] <컨테이너이름>     // 컨테이너가 생성한 로그 확인
```












