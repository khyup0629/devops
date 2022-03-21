# 앤서블 설치(Ubuntu)

앤서블은 `apt` 명령어로 설치할 경우 최신 버전을 지원하고 있지 않기 때문에 `python` 설치 명령어인 `pip`를 이용합니다.

먼저 파이썬 패키지를 설치합니다.   
```
sudo apt install python3-pip
```

앤서블을 설치합니다.   
```
pip install ansible
```

설치를 완료하면 터미널에서 잠시 나갔다가 다시 접근합니다.   
```
exit
```

설치가 잘 되었는지 경로와 버전을 확인해봅니다.   
```
which ansible
ansible --version
```

![image](https://user-images.githubusercontent.com/43658658/159229086-6c0bfd42-100d-4948-8999-1eba9cdc5f8d.png)


