# 쿠버네티스 실습을 위한 노드 생성하기

## 마스터 노드 생성

쿠버네티스의 마스터 노드(m)를 아래와 같은 스펙으로 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/151119906-b41807b4-e317-457c-b752-e5c726cdedd4.png)

`ifconfig`로 네트워크 이름과 주소를 확인합니다.   
![image](https://user-images.githubusercontent.com/43658658/151128534-d241588d-de34-4a3c-8818-0fa7e1b0e555.png)   
- `ifconfig`를 명령할 수 없다면, `yum -y install net-tools`를 설치합니다.

`/etc/sysconfig/network-scripts`의 경로에서 `ifcfg-<네트워크이름>`을 편집해서 IP 주소를 변경합니다.   
```
vi /etc/sysconfig/network-scripts/ifcfg-ens192
```   
![image](https://user-images.githubusercontent.com/43658658/151130451-3944e307-aa54-4e39-b5e7-c36347bdbdc4.png)

`systemctl restart network`를 통해 네트워크를 재시작해서 변경사항을 적용하고, 다시 `ifconfig`를 통해 IP 주소가 변경되었는지 확인합니다.   
```
systemctl restart network
ifconfig
```   
![image](https://user-images.githubusercontent.com/43658658/151129496-714f3af5-7a66-4e33-b9ba-899af26ae63d.png)

## 워커 노드 생성

쿠버네티스의 워커 노드들(w1, w2, w3)을 아래와 같은 스펙으로 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/151121776-d476d334-ec38-4b7a-aaee-8bd77add382d.png)

