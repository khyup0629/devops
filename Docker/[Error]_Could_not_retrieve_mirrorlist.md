# Could not retrieve mirrorlist

CentOS에서 yum 명령어 입력 시 미러사이트와 관련된 오류가 발생할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/151123583-a320ed2b-5f31-4ff5-a226-cb1d022897dc.png)

네임서버를 조회하지 못해 발생하는 오류입니다.

1. `cat /etc/resolv.conf`를 입력하면 아무 내용도 출력되지 않습니다.   
```
cat /etc/resolv.conf

```   
![image](https://user-images.githubusercontent.com/43658658/151125913-28326652-cd2d-4795-a65d-c5266a7445cd.png)

2. `ifcfg-XXX` 파일을 확인합니다.   
```
vi /etc/sysconfig/network-script/ifcfg-ens192
ONBOOT=yes    // no -> yes 로 변경.
DNS=8.8.8.8   // 해당 내용 추가.
```   
![image](https://user-images.githubusercontent.com/43658658/151126080-01641f37-a25c-4fa3-b986-784e8dc83166.png)

3. 재실행(`reboot`)합니다.

4. 다시 `cat /etc/resolv.conf`를 입력하면 네임서버가 정상적으로 조회됩니다.     
![image](https://user-images.githubusercontent.com/43658658/151126218-847b8194-c22f-4160-85a5-95ae97149b43.png)

`yum` 명령어도 정상적으로 수행됩니다.   
![image](https://user-images.githubusercontent.com/43658658/151126302-d6402247-2dac-4b18-b726-257781e85a6a.png)
