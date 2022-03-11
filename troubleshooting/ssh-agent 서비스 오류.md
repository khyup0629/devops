# ssh-agent 실행 시 아래와 같은 오류 발생

![image](https://user-images.githubusercontent.com/43658658/157788567-ddb5c40a-f602-4d73-9386-f88a8896ce20.png)

## 해결 방법

오류는 ssh-agent가 설치되었지만 서비스가 시작되지 않았음을 의미합니다.

PowerShell에서 서비스 시작 여부를 확인할 수 있습니다.   
```
Get-Service ssh-agent
```   
![image](https://user-images.githubusercontent.com/43658658/157788647-b5c62b6f-197c-41e5-94dd-763abe840ce1.png)

```
Get-Service ssh-agent | Select StartType
```   
![image](https://user-images.githubusercontent.com/43658658/157788657-3b2b4b1d-3f9b-4fc8-b8f5-366ab06cded6.png)

위와 같이 `Disabled`라면 수동으로 서비스를 시작하도록 설정할 수 있습니다(관리자 권한 실행 필요).   
```
Get-Service -Name ssh-agent | Set-Service -StartupType Manual
```   

```
Get-Service ssh-agent | Select StartType
```   
![image](https://user-images.githubusercontent.com/43658658/157789420-c02b3cf1-f5ff-43aa-a5b7-094ba3347573.png)
