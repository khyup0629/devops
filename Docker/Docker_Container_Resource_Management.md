# 컨테이너 리소스 관리

## 컨테이너 하드웨어 리소스 제한

컨테이너가 필요로 하는 만큼의 리소스만 할당해 주는 것이 필요합니다.

- Docker 명령어를 통해 제한할 수 있는 리소스 : CPU, 메모리, 디스크 I/O

> <h3>메모리 리소스 제한</h3>

- `-m A` : 최대 메모리
- `-m A --memory-reservation B` : 최소 B, 최대 A의 메모리 사용 가능
- `-m A --memory-swap B` : 최대 메모리 A, 스왑 메모리는 B-A, 스왑 메모리를 생략하면 자동으로 메모리의 2배가 할당
- `--oom-kill-disable` : 메모리가 부족하게 되면 Out-of-memory killer를 동작시켜 프로세스를 죽이는데, 그걸 방지하는 옵션입니다.

```
docker run -d -m 512m nginx:1.14
docker run -d -m 1g --memory-reservation 500m nginx:1.14
docker run -d -m 200m --memory-swap 300m nginx:1.14
docker run -d -m 200m --oom-kill-disable nginx:1.14
```

> <h3>CPU 리소스 제한</h3>

- `--cpus` : 컨테이너에 할당할 **CPU core**수를 지정
- `--cpuset-cpus` : 컨테이너가 사용할 수 있는 CPU나 코어를 할당. 인덱스로 할당.
- `--cpu-share` : 1024 값을 기반으로 CPU 비중 설정. 상대적으로 설정. --cpu-share 2048 이라면, 기본값보다 두 배 많은 CPU 자원 할당

```
docker run -d --cpus=".5" ubuntu:1.14
docker run -d --cpu-share 2048 ubuntu:1.14
docker run -d --cpuset-cpus 0-3 ubuntu:1.14
```

> <h3>Block I/O 제한</h3>

- `--blkio-weight`, `--blkio-weight-device` : Block I/O의 Quota를 상대값으로 설정. default 500. 100~1000까지 할당 가능.
- `--device-read-bps`, `--device-write-bps` : 특정 디바이스에 대한 읽기와 쓰기 작업의 초당 제한을 설정(단위 : kb, mb, gb)
- `--device-read-iops`, `--device-write-iops` : 컨테이너의 read/write 속도의 쿼터를 설정. 초당 quota를 제한해서 I/O를 발생시킴. 0 이상의 정수로 표기.

```
docker run -it --rm  --blkio-weight 100 ubuntu:latest /bin/bash
docker run -it --rm --device-write-bps /dev/vda:1mb ubuntu:latest /bin/bash
docker run -it --rm --device-write-iops /dev/vda:10 ubuntu:latest /bin/bash
```

## 컨테이너 사용 리소스 확인 툴

- `docker stat` : 실행중인 컨테이너의 런타임 통계
- `docker event` : Docker HOST의 실시간 event 정보를 수집해서 출력.

- `cAdvisor` : 컨테이너 리소스 모니터링 애플리케이션.



