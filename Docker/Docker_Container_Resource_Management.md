# 컨테이너 리소스 관리

## 컨테이너 하드웨어 리소스 제한

컨테이너가 필요로 하는 만큼의 리소스만 할당해 주는 것이 필요합니다.

- Docker 명령어를 통해 제한할 수 있는 리소스 : CPU, 메모리, 디스크 I/O

> <h3>리눅스 부하 테스트 프로그램 - stress</h3>

```
stress -c 2      // cpu core 2개에 100% 부하 발생
stress --vm 2 --vm-bytes <사용할 크기>       // 메모리 부하 : 프로세스 개수와 메모리 크기를 지정
```

> <h3>메모리 리소스 제한</h3>

- `-m A` : 최대 메모리
- `-m A --memory-reservation B` : 최소 B, 최대 A의 메모리 사용 가능
- `-m A --memory-swap B` : 최대 메모리 A, 스왑 메모리는 B-A, 스왑 메모리를 생략하면 자동으로 메모리의 2배가 할당
- `--oom-kill-disable` : 메모리가 부족하게 되면 Out-of-memory killer를 동작시켜 프로세스를 죽이는데, 그걸 방지하는 옵션입니다.

```
docker run -d -m 512m nginx:1.14
docker run -d -m 1g --memory-reservation 500m nginx:1.14
docker run -d -m 200m --memory-swap 300m nginx:1.14
docker run -d -m 200m --oom-kill-disable=true nginx:1.14
```

> <h3>메모리 리소스 제한 실습</h3>

```
mkdir stress
cd stress
vim dockerfile
docker build -t stress .
```   
<dockerfile 내용>   
```
FROM debian
RUN apt-get update \
  && apt-get install -y stress
CMD ["/bin/sh", "-c", "stress -c 2"]
```

```
docker run -m 100m --memory-swap 100m stress stress --vm 1 --vm-bytes 90m -t 5s
docker run -m 100m --memory-swap 100m stress stress --vm 1 --vm-bytes 150m -t 5s
```   
![image](https://user-images.githubusercontent.com/43658658/152724464-fa0c6b76-7f97-482a-bf77-cf6c87a95e18.png)   

> <h3>CPU 리소스 제한</h3>

- `--cpus` : 컨테이너에 할당할 **CPU core**수를 지정
- `--cpuset-cpus` : 컨테이너가 사용할 수 있는 CPU나 코어를 인덱스로 할당.
- `--cpu-share` : 1024 값을 기반으로 CPU 비중 설정. 상대적으로 설정. --cpu-share 2048 이라면, 기본값보다 두 배 많은 CPU 자원 할당

```
docker run -d --cpus=".5" ubuntu:1.14
docker run -d --cpu-share 2048 ubuntu:1.14
docker run -d --cpuset-cpus 0-3 ubuntu:1.14
```

> <h3>CPU 리소스 제한 실습</h3>

```
docker run --cpuset-cpus 1 --name c1 stress stress -c 1
htop        // 전체 CPU core 2개에 대한 부하를 보여줍니다.
```   
![image](https://user-images.githubusercontent.com/43658658/152725023-b16f3ec0-97f3-4289-8c2a-c6d455e543a4.png)   
- 인덱스를 1로 주어 2번째 cpu core에 부하가 발생함을 볼 수 있습니다.

```
docker run --cpuset-cpus 0 --name c1 stress stress -c 1
htop
```   
![image](https://user-images.githubusercontent.com/43658658/152725474-2b76aa9c-c60f-4c13-847b-70a1864519de.png)   
- 인덱스를 0으로 주면 1번째 cpu core에 부하가 발생합니다.

```
docker run --cpuset-cpus 0-1 --name c2 -d stress stress -c 1
```   
![image](https://user-images.githubusercontent.com/43658658/152725981-d8acaeb2-61a1-413b-b504-da0e2b05ce08.png)   
- cpu 2개를 합쳐서 100%가 되도록 부하를 줍니다.

상대적 비율로 CPU를 할당할 때는 `docker run` 뒤에 command를 쓰지 않습니다.   
```
docker run -c 2048 --name cload1 -d stress      // CPU를 기본값보다 2배 할당
docker run --name cload2 -d stress
docker run -c 512 --name cload3 -d stress       // CPU를 기본값보다 0.5배 할당
docker run -c 512 --name cload4 -d stress       // CPU를 기본값보다 0.5배 할당
```   

```
docker stats        // 프로세스 별 부하를 보여줍니다.
```   
![image](https://user-images.githubusercontent.com/43658658/152988454-3ce6dd2e-e9eb-4348-b18b-9e74bd97f666.png)   
- 전체 CPU core 2개에 100% 부하를 주어 총 200% 부하에서 상대적 비율에 맞게 4개의 CPU에 할당합니다(4 : 2 : 1 : 1)


> <h3>Block I/O 제한</h3>

- `--blkio-weight`, `--blkio-weight-device` : Block I/O의 Quota를 상대값으로 설정. default 500. 100~1000까지 할당 가능.
- `--device-read-bps`, `--device-write-bps` : 특정 디바이스에 대한 읽기와 쓰기 작업의 초당 제한을 설정(단위 : kb, mb, gb)
- `--device-read-iops`, `--device-write-iops` : 컨테이너의 read/write 속도의 쿼터를 설정. 초당 quota를 제한해서 I/O를 발생시킴. 0 이상의 정수로 표기.

```
docker run -it --rm  --blkio-weight 100 ubuntu:latest /bin/bash
docker run -it --rm --device-write-bps /dev/vda:1mb ubuntu:latest /bin/bash
docker run -it --rm --device-write-iops /dev/vda:10 ubuntu:latest /bin/bash
```

`lsblk`를 통해 현재 마운트 되어 있는 디스크를 봅니다.   
```
lsblk
```   
![image](https://user-images.githubusercontent.com/43658658/152991908-6be951ff-34ad-4dfc-9af8-7ea0daee896b.png)   

`sda` 디스크를 고르고, 쿼터가 10인 디스크 성능으로 컨테이너를 하나 올린 뒤 컨테이너 터미널로 들어갑니다..   
```
docker run -it --rm --device-write-iops /dev/sda:10 ubuntu /bin/bash
```

터미널에서 블럭 사이즈 1M를 10번 file1을 통해 입/출력하는 성능 테스트를 진행합니다.   
```
/# dd if=/dev/zero of=file1 bs=1M count=10 oflag=direct
```   
![image](https://user-images.githubusercontent.com/43658658/152992571-00f5ec35-4c4e-4ea1-b24c-fb7f9bc29ddc.png)

이번엔 쿼터가 100인 `sda` 디스크 성능으로 컨테이너를 올리고 터미널로 접속합니다.   
```
docker run -it --rm --device-write-iops /dev/sda:100 ubuntu /bin/bash
```

마찬가지로 같은 스펙으로 성능 테스트를 진행합니다.   
```
/# dd if=/dev/zero of=file1 bs=1M count=10 oflag=direct
```   
![image](https://user-images.githubusercontent.com/43658658/152992918-b5664db4-bd2a-48de-9e19-218aa6959da1.png)   
- 성능 차이가 확연히 다른 것을 확인할 수 있습니다.

## 컨테이너 사용 리소스 확인 툴

- `docker stats` : 실행중인 컨테이너의 런타임 통계
- `docker event` : Docker HOST의 실시간 event 정보를 수집해서 출력.

- `cAdvisor` : 컨테이너 리소스 모니터링 애플리케이션.

> <h3>cAdvisor 사용</h3>

=> [cAdvisor 설치](https://github.com/google/cadvisor)   

위 사이트에 접속한 뒤 아래에 **README.md** 부분의 코드를 복사해서 그대로 Docker HOST에서 실행합니다.   
![image](https://user-images.githubusercontent.com/43658658/152994440-96678ad3-4ede-4cbb-8ffb-e23fbd25479d.png)   
```
VERSION=v0.36.0 # use the latest release version from https://github.com/google/cadvisor/releases
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor:$VERSION
```

```
docker ps -a
```   
![image](https://user-images.githubusercontent.com/43658658/152995437-4a38cde2-b8bb-402b-a978-2cc3547ca2c3.png)   
- `cadvisor` 컨테이너가 실행되었습니다.

메모리와 디스크 I/O를 할당한 컨테이너를 하나 실행합니다.   
```
docker run -it --rm --device-write-iops /dev/sda:100 -m 500m --name c1 -d ubuntu /bin/bash
```

이제 웹 브라우저에서 **Docker HOST의 IP 주소**에 **8080번 포트**로 접속합니다.   
![image](https://user-images.githubusercontent.com/43658658/152995715-9d8fdc84-672d-4e3e-9c93-7a7510d6dfdc.png)   
- cAdvisor를 확인할 수 있습니다.

`Docker Containers`를 클릭하면 개별 컨테이너에 대한 지표들을 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/152996376-5a6f809f-f068-4854-9bec-d926fd7e3cc2.png)   
![image](https://user-images.githubusercontent.com/43658658/152996665-a56863ae-189f-4a18-a608-900477192049.png)   
![image](https://user-images.githubusercontent.com/43658658/152996628-8866c9df-b4af-492d-ba7f-9fd70cb817f1.png)









