# Let's encrypt를 이용한 SSL 인증서 발급

먼저 클라우드의 인스턴스로 SSL 인증서 발급 및 갱신용 서버를 하나 만듭니다.   
(최소 사양, CentOS)

서버로 접속해서 `Let's encrypt`를 설치합니다.

```
yum update -y
yum install epel-release -y
yum install python2-certbot-apache -y
```

원하는 도메인에 대해 인증서를 획득합니다.   
(도메인은 도메인 인증 기관을 통해 A 레코드를 추가합니다. 값은 SSL 인증서를 등록할 IP 주소를 참조하도록 합니다)   
![image](https://user-images.githubusercontent.com/43658658/158108504-dbce7960-1fba-4e07-9624-ec1892096a39.png)

```
certbot --standalone -d <원하는 도메인> certonly
```

인증서를 발급 받으면 아래와 같이 4개의 파일이 생성됩니다.   
![image](https://user-images.githubusercontent.com/43658658/158108794-41e38556-16fa-4ae3-b11f-17282e45b091.png)


## 클라우드에 SSL 인증서 등록

Let's Encrypt를 통해 인증서를 발급 받을 경우, `Root CA` 인증서와 `Sub CA` 인증서의 내용을 `chain`으로 묶는 작업을 수동으로 행해줘야 합니다.

해당 작업은 윈도우에서만 가능하므로, 서버 안의 인증서를 잠시 바깥으로 빼내겠습니다.

먼저, `cert.pem` 파일을 `cert.crt` 파일로 확장자를 변경합니다.   
```
cp -rp cert.pem cert.crt
```

`Filezilla`를 열고 SSL 인증서 발급 서버로 접근합니다.   

`/etc/letsencrypt/live/<도메인>`으로 접근해 `cert.crt` 파일을 윈도우로 빼냅니다.   
![image](https://user-images.githubusercontent.com/43658658/158109340-27ebab0f-136e-459c-8b99-a5e41a53fa7d.png)

`cert.crt` 파일을 엽니다. `인증 경로` 탭으로 들어가면 `Root CA`와 `Sub CA`가 보입니다.   
![image](https://user-images.githubusercontent.com/43658658/158109492-6b7a1062-857e-4519-b705-7e1d468e96aa.png)

`Root CA` 인증서를 클릭하고 `인증서 보기`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/158109517-134620aa-c8ac-4da8-a5a3-8a7c6c0ce9c0.png)

`자세히` 탭으로 접속해 `파일에 복사`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/158109555-3589db44-bf86-4d50-93d5-7c6dbc38d46a.png)

인증서 내보내기 마법사가 시작됩니다.   
![image](https://user-images.githubusercontent.com/43658658/158111105-12f7edcb-dc5b-4fe1-98f2-32d8d38d8278.png)

아래와 같이 진행하여 `CA.crt` Root CA 인증서 파일을 내보냅니다.   
![image](https://user-images.githubusercontent.com/43658658/158109600-80caadfb-b744-4c7f-ba35-b67546a1ab24.png)   
![image](https://user-images.githubusercontent.com/43658658/158109637-9efe337c-ef89-438f-8eef-f7c47f15ec0e.png)

다시 `cert.crt`의 `인증 경로` 탭으로 돌아와 이번엔 `Sub CA` 인증서를 클릭하고 `인증서 보기`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/158109750-db5ee396-420f-499a-a432-364a73d90dc0.png)

마찬가지로 `자세히` 탭으로 들어가 `파일에 복사`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/158109802-5d288a64-4b42-4b30-baab-69874249d353.png)

Root CA 인증서를 내보낼 때와 동일한 방식으로 진행합니다.   
![image](https://user-images.githubusercontent.com/43658658/158109870-008f9c58-78a4-46ae-b8a8-a25e293ff09f.png)   
![image](https://user-images.githubusercontent.com/43658658/158109882-c651a947-1577-4362-853d-06fcbbea85cc.png)

`cert.crt`, `CA.crt`, `intermediate.crt` 파일을 모두 `.pem` 확장자로 변경합니다.   
![image](https://user-images.githubusercontent.com/43658658/158109970-62e93118-4cad-4210-a550-a2e9da4e3f7f.png)

클라우드 콘솔에서 `Certificate Manager`를 열고, `외부 인증서 가져오기`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/158110058-a738139c-be45-407e-8526-bb585c8390c9.png)

각 항목은 아래와 같이 매칭되는 파일 내용을 붙여넣습니다.   
(붙여넣을 때는 `-----BEGIN CERTIFICATE-----` ~ `-----END CERTIFICATE-----`까지 모두 붙여넣습니다)   
- **Private Key** : `private.pem`
- **Certificate Body** : `cert.pem`
- **Certificate Chain** : `intermediate.pem` + `CA.pem`

![image](https://user-images.githubusercontent.com/43658658/158110188-d7e6691a-72e9-45e3-b81e-e2a35d9f74ee.png)   
- Certificat Chain의 경우 `intermediate.pem` 내용을 붙여넣고, 바로 다음 줄에 `CA.pem` 내용을 붙여넣으면 됩니다.

`추가` 버튼을 누르면 인증서 등록이 완료됩니다.

# 주의할 점!

만약 Load Balancer에 SSL 인증서를 적용할 경우 인증서를 발급 받을 때 **<인증한 도메인>에 대해서 HTTPS가 적용**되고,   
기존 LB의 **엔드포인트로는 적용되지 않습니다.**

참고 사이트 :   
- [Let's Encrypt을 이용한 SSL 인증서 발급 및 등록](https://navercloudplatform.medium.com/%EC%9D%B4%EB%A0%87%EA%B2%8C-%EC%82%AC%EC%9A%A9%ED%95%98%EC%84%B8%EC%9A%94-lets-encrypt-%EB%AC%B4%EB%A3%8C-ssl-%EC%9D%B8%EC%A6%9D%EC%84%9C-%EB%B0%9C%EA%B8%89%EB%B6%80%ED%84%B0-%EB%93%B1%EB%A1%9D-%EA%B4%80%EB%A6%AC%EA%B9%8C%EC%A7%80-feat-certificate-manager-d259f469e83d)
- [Let's Encrypt을 이용한 SSL 인증서 발급 및 등록 - 1](https://manvscloud.com/?p=1445)
