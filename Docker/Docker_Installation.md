# 도커 설치

- 컴퓨터 스펙 최소 사양 - **CPU : 2core, Memory : 2GB**   
- OS : **Ubuntu 20.04**   
- IP Address : **172.16.0.201**   

## Repository를 이용한 설치

인터넷과 통신이 가능할 때 Repository를 사용해 설치하는 방법입니다.   
=> [도커 공식 사이트 참고](https://docs.docker.com/engine/install/ubuntu/#:~:text=to%20install%20Docker.-,Install%20using%20the%20repository,-%F0%9F%94%97)

> <h3>리포지토리 셋업</h3>

도커를 설치하기 위해 **요구하는 패키지**를 모두 설치합니다.   
```
sudo apt-get update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

도커를 사용하기 위한 **공식 GPG 키(인증서)** 를 저장합니다.   
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

도커의 우분투 **리포지토리 URL**을 등록합니다.   
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

> <h3>도커 엔진 설치</h3>

```
sudo apt-get update       // 앞서 리포지토리 URL을 등록해 주었기 때문에 반드시 업데이트를 해야 합니다.
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
```

도커 엔진이 잘 설치되었는지 테스트를 진행합니다.   
```
sudo docker version
```   
![image](https://user-images.githubusercontent.com/43658658/152484929-ec5f8c21-2142-4119-9688-052be82768f0.png)   
* Client 버전과 Server 버전이 보입니다.






