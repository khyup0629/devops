# 네트워크 프록시 로드밸런서(NPLB)에 SSL 인증서 적용

이 과정은 현재 `Certificate Manager`에 SSL 인증서가 등록이 되어 있다는 전제 하에 진행되는 과정입니다.

=> [Let's Encrypt를 이용한 SSL 인증서 발급 및 클라우드 등록](https://github.com/khyup0629/devops/blob/main/etc/Let's%20Encrypt%EB%A5%BC%20%ED%86%B5%ED%95%9C%20SSL%20%EC%9D%B8%EC%A6%9D%EC%84%9C%20%EB%B0%9C%EA%B8%89%20%EB%B0%8F%20%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C%20%EB%93%B1%EB%A1%9D.md#lets-encrypt%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9C-ssl-%EC%9D%B8%EC%A6%9D%EC%84%9C-%EB%B0%9C%EA%B8%89)

## 로드밸런서 인프라 구축

> <h3>서버 생성</h3>

먼저 로드밸런서의 뒤에 위치할 서버 2개를 구축합니다.   
(CentOS 기반)   

양측 서버 모두 웹 서버를 구축해줍니다.   

```
yum update -y
yum install epel-release -y
yum install nginx -y
```

- `nginx`의 `index.html`의 위치는 `/usr/share/nginx/html` 내에 있습니다.
- 서버의 보안 그룹은 `22`, `80`, `443`에 대해 `0.0.0.0/0`으로 열어줍니다.   
![image](https://user-images.githubusercontent.com/43658658/158113495-0ca0222d-68df-4e0c-b95e-bdcd30df4895.png)

> <h3>Target Group 생성</h3>

`Network Proxy Load Balancer`를 위한 `Target Group`을 생성합니다.   
(프로토콜은 Network Proxy LB이므로 `PROXY_TCP`로 지정했습니다)   
![image](https://user-images.githubusercontent.com/43658658/158111748-a6765792-2e45-485d-be08-dd5cca442e3a.png)   

Health Check에 대한 설정을 진행합니다.   
![image](https://user-images.githubusercontent.com/43658658/158111874-c2f32633-1d89-49b2-8401-1dff8f47c720.png)

앞서 생성한 2개의 서버를 Target으로 설정합니다.   
![image](https://user-images.githubusercontent.com/43658658/158111955-01a49b1d-f3d3-4aee-934d-51280d4f20c3.png)

> <h3>NPLB 생성</h3>

`네트워크 프록시 로드밸런서`를 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/158112577-0601e205-43f3-4905-a812-1cfa69064976.png)

![image](https://user-images.githubusercontent.com/43658658/158112648-c5f9dd38-150a-45a6-9763-a6e1f591d55a.png)

`TLS - 443 / TCP - 80` 리스너를 추가합니다.   
(TLS - 443 리스너를 추가하면 다음 단계에 인증서를 등록하는 단계가 추가됩니다)   
![image](https://user-images.githubusercontent.com/43658658/158112733-e7a1f59f-da53-42ac-a465-67e37c014f9e.png)

`Certificate Manager`에 등록한 인증서를 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/158112826-de53450d-ebb5-46be-bcb2-22db1ec3c5b5.png)

이전 과정에서 생성한 `Target Group`을 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/158112884-00e4500c-ffe9-4236-beb8-dee83d9b59a8.png)

## 테스트

SSL 인증서를 발급 받을 때 사용한 도메인으로 로드밸런싱이 되는지 확인합니다.   
더불어 `HTTPS`의 적용 여부 역시 확인합니다.

![image](https://user-images.githubusercontent.com/43658658/158113312-dfb97b7d-eb44-4620-8049-750d98cc9914.png)   
![image](https://user-images.githubusercontent.com/43658658/158113330-9afa463e-f565-47d2-9839-35ad6ba70ac6.png)

## 주의할 점!

인증서를 발급 받을 때 **<인증한 도메인>에 대해서 HTTPS가 적용**되고,   
기존 LB의 **엔드포인트로는 적용되지 않습니다.**
