# 프로메테우스 TCP 에러

프로메테우스의 config 파일 `prometheus.yml`에서 `targets: [ host.docker.internal:8080 ]` 또는 `targets: [ localhost:8080 ]`으로 설정했을 시 아래와 같은 에러 발생.
![image](https://user-images.githubusercontent.com/43658658/154506763-c56752ab-caf8-4a50-a760-76c6fc2beba2.png)   
![image](https://user-images.githubusercontent.com/43658658/154506861-cfa374fd-8fe2-42d2-b85b-91700e1d718b.png)

# 해결 방법

`targets: [ '172.16.0.202:8080' ]`으로 설정할 시 해결됩니다.   
![image](https://user-images.githubusercontent.com/43658658/154507245-9975e836-6c36-43fd-9f25-5729236403e0.png)
