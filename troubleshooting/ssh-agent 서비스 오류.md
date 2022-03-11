# ssh-agent 실행 시 아래와 같은 오류 발생

![image](https://user-images.githubusercontent.com/43658658/157788567-ddb5c40a-f602-4d73-9386-f88a8896ce20.png)

## 해결 방법

오류는 ssh-agent가 설치되었지만 서비스가 시작되지 않았음을 의미합니다.

PowerShell에서 서비스 시작 여부를 확인할 수 있습니다.   
```
Get-Service ssh-agent
```   
![image](https://user-images.githubusercontent.com/43658658/157788647-b5c62b6f-197c-41e5-94dd-763abe840ce1.png)

ssh-agent의 실행 타입을 봅니다.   
```
Get-Service ssh-agent | Select StartType
```   
![image](https://user-images.githubusercontent.com/43658658/157788657-3b2b4b1d-3f9b-4fc8-b8f5-366ab06cded6.png)

위와 같이 `Disabled` 상태라면 시작 타입을 수동으로 설정합니다.   
```
Get-Service -Name ssh-agent | Set-Service -StartupType Manual
```   

다시 `StartType`을 확인합니다.   
```
Get-Service ssh-agent | Select StartType
```   
![image](https://user-images.githubusercontent.com/43658658/157791060-c846c2bd-4973-4fe1-943b-28289a5eefed.png)

