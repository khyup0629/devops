# Could not open a connection to your authentication agent.

`ssh-add` 명령어를 실행하는 과정에서 위의 에러 메시지를 확인했습니다.   
![image](https://user-images.githubusercontent.com/43658658/159402014-41bc1c6c-5a3b-42c4-b0a3-9f64fcc69416.png)   

## 해결 방법

이는 한 번도 ssh-agent를 사용하지 않았을 때 발생하는 에러이므로 아래의 명령을 입력해 ssh-agent를 시작합니다.   
```
eval $(ssh-agent)
```

다시 `ssh-add`를 실행하면 성공적으로 키 파일이 등록됩니다.   
