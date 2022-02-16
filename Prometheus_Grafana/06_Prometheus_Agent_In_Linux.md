# 프로메테우스 에이전트 설치

먼저 아래의 사이트에 접속해 `node_exporter` 압축 파일의 링크를 복사합니다.
=> [node exporter 압축 파일 링크 복사](https://prometheus.io/download/)   
![image](https://user-images.githubusercontent.com/43658658/147640815-7a932841-84bc-4fe7-960a-e3955d7bc552.png)

`cd /home` 경로로 들어가서 복사한 링크를 붙여넣기해서 압축 파일을 다운 받습니다.   
![image](https://user-images.githubusercontent.com/43658658/147640911-f2f3890e-52b2-4950-b168-6b6b8d0d3bf6.png)

압축을 해제합니다.   
![image](https://user-images.githubusercontent.com/43658658/147640923-fc8c88db-00f0-4e41-8f11-ed636c392720.png)

`/home/node_exporter-1.3.1.linux-amd64` 경로에 `node_exporter`가 생성되어 있음을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/147641013-31f4b984-960a-413e-b9e1-b94df70a8e50.png)   

`./node_exporter`로 node exporter를 실행하면, node_exporter라는 프로메테우스 에이전트가 현재 ENN 서버에서 매트릭 값을 가져옵니다.   
![image](https://user-images.githubusercontent.com/43658658/147642572-508e75f4-b739-490a-827a-fd109be4cebc.png)

하지만 node_exporter를 항상 실행한 채로 둘 수는 없기 때문에 node_exporter를 데몬에 서비스로 등록하겠습니다.

```
mv /home/node_exporter-1.3.1.linux-amd64 /home/node_exporter    // 디렉토리 이름을 변경합니다.
vim /etc/systemd/system/node_exporter.service                   // node_exporter를 서비스로 등록하는 설정을 진행합니다.
```

<node_exporter.service>   
![image](https://user-images.githubusercontent.com/43658658/147642620-ea3398a3-660b-4767-a866-52ce3c7edb26.png)

데몬을 재시작해주면 설정이 완료됩니다.

```
systemctl daemon-reload
```

마지막으로 등록한 `node_exporter.service` 서비스를 실행합니다.

```
systemctl enable node_exporter.service  // 서비스 상시 가동
systemctl start node_exporter.service   // 서비스 시작
systemctl status node_exporter.service  // 서비스 가동 상태 확인
```

![image](https://user-images.githubusercontent.com/43658658/147714364-b4982b6f-4577-41d6-b6c7-e9c0faa1d4a8.png)
