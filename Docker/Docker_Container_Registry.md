# Docker Registry

- **Registry** : 컨테이너 이미지를 저장하는 Docker HOST 디스크 외의 저장소
- **Public Registry(Docker Hub)** : 인터넷 상에 존재하는 저장소, hub.docker.com
- **Private Registry(registry)** : 사내의 컨테이너 저장소

## Public Registry(Docker Hub)

=> https://hub.docker.com/

![image](https://user-images.githubusercontent.com/43658658/152677336-4beb8328-dbc7-4955-ba73-1411b346377d.png)   
- official images : **도커 공식 사이트**에서 관리하는 컨테이너 이미지입니다.
- verified Publisher : **벤더사**에서 제공하고 관리하는 이미지입니다.

`Sign in`을 통해 **로그인** 한 뒤 `Repository`로 들어갑니다.   
![image](https://user-images.githubusercontent.com/43658658/152677664-bd9dffc2-a1ed-4cb3-ac7e-7717e41725f4.png)
- 이 공간은 계정 소유자만 업로드가 가능하고, 다운로드는 모두 받을 수 있는 공간입니다.
- **Docker Hub**에서 계정 소유자만 업로드/다운로드 할 수 있는 **개인 저장소**는 1개 까지 무료로 생성이 가능합니다.

> <h3>리눅스 환경에서 Docker Hub를 이용하는 방법</h3>

`docker search <원하는 이미지 키워드>` 명령어를 통해 **Docker Hub**에서 **컨테이너 이미지**를 검색할 수 있습니다.   
```
docker search httpd
```   
![image](https://user-images.githubusercontent.com/43658658/152677992-bbeac4e1-4f57-46d8-9c86-9ee9817816b3.png)   
- Name, Description에 해당 키워드가 있을 경우 검색됩니다.

`docker pull <원하는 이미지 이름>`을 통해 **Docker Hub**의 **컨테이너 이미지**를 Docker HOST의 디스크에 저장할 수 있습니다.   
```
docker pull httpd:latest
```   
![image](https://user-images.githubusercontent.com/43658658/152678054-de3131a4-d75e-4c40-b2b1-cf687c9c647b.png)   
- `:latest`의 경우 버전을 의미하고, latest는 가장 최신 버전을 의미합니다. latest는 생략이 가능합니다.

`docker images httpd`로 디스크에 저장된 `httpd` 이미지를 검색해봅니다.   
![image](https://user-images.githubusercontent.com/43658658/152678154-a697b1ea-b670-449d-86f8-b57f6ac199b2.png)

이미지를 **개인 리포지토리**에 **업로드**할 수 있습니다.

먼저, `docker login`을 통해 Docker Hub에 로그인합니다.   
![image](https://user-images.githubusercontent.com/43658658/152678295-f89b1f51-1c45-4ebe-a401-cbcb13d1fb67.png)   
- 이전에 로그인한 이력이 있을 경우 별다른 ID/패스워드를 물어보지 않습니다.

이미지의 이름 앞에 `계정ID/`를 붙여줍니다.   
```
docker tag httpd 계정ID/httpd
```   
![image](https://user-images.githubusercontent.com/43658658/152678370-7fac2941-9a33-4a00-949e-31ad4077401d.png)   
![image](https://user-images.githubusercontent.com/43658658/152678383-c70c8a97-642a-45df-a0e6-de5a6411b077.png)   

**개인 리포지토리**에 업로드(**push**)합니다.   
```
docker push khyup0629/httpd
```   
![image](https://user-images.githubusercontent.com/43658658/152678457-85867bc5-9b1c-46b9-bf71-fde93f52c4c1.png)

**Docker Hub 사이트**에 접속해서 **개인 리포지토리**를 확인해봅니다.   
![image](https://user-images.githubusercontent.com/43658658/152678535-7f5d4b59-3ee9-4dfe-b608-7a155ac10f40.png)

## Private Registry(registry)

사내에서만 운영할 수 있는 **프라이빗 레지스트리**를 구축할 수 있습니다.

프라이빗 레지스트리를 컨테이너로 올릴 수 있도록 해주는 이미지는 바로 **registry**입니다.   
![image](https://user-images.githubusercontent.com/43658658/152677779-79b9525e-5338-40de-ba92-9ceaf716a041.png)

> <h3>registry 구축</h3>

registry를 컨테이너로 올립니다.   
```
docker run -d -p 5000:5000 --restart always --name registry registry:2
```   
- `-d` : 백그라운드 실행
- `-p A:B` : Docker HOST에서 A 포트로 접속하면 컨테이너의 B 포트로 **포트포워딩**됩니다.
- `--restart always` : 컨테이너가 종료되면 **항상 재시작**됩니다.
- `--name <이름>` : 컨테이너의 이름을 지정합니다.

![image](https://user-images.githubusercontent.com/43658658/152679278-0b3127b1-ab29-4276-bfcb-c71d2a6455d3.png)   
- docker HOST의 디스크에 해당 이미지가 없다면 자동으로 `Pull`한 다음 컨테이너를 실행합니다.

컨테이너가 정상적으로 실행되고 있는지 확인합니다.   
```
docker ps
```   
![image](https://user-images.githubusercontent.com/43658658/152679280-9314b56a-be1e-41e6-a349-6122bdefa778.png)

이번에는 로컬에 올라가 있는 registry 컨테이너에 `push`해야하므로 태그를 아래와 같이 변경해줍니다.   
```
docker tag httpd localhost:5000/httpd
docker images localhost:5000/httpd
```   
![image](https://user-images.githubusercontent.com/43658658/152679347-e7fc8938-d184-4850-a84a-9ec6b2712ce7.png)

registry에 httpd 이미지를 업로드합니다.   
```
docker push localhost:5000/httpd
```   
![image](https://user-images.githubusercontent.com/43658658/152679361-f87bc8e2-6a0f-4817-890c-e11289b5790d.png)

registry에 업로드된 컨테이너 이미지는 `/var/lib/docker/volumes/<컨테이너UUID>/_data/docker/registry/v2/repositories` 경로 내에 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/152679506-4f3849f1-d881-4045-8513-1ffeb1638945.png)



















