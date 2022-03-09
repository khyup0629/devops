# git push 오류

git push 시 해당 오류가 발생하며 Push가 되지 않았습니다.   
![image](https://user-images.githubusercontent.com/43658658/157381554-e6fdbd10-565c-48c4-b947-8284b2c4ea8f.png)

# 토큰 생성

=> [토큰 생성 가이드](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

위 가이드를 보고 토큰을 생성합니다.

주의할 점은 `Select scopes` 에서 모든 옵션을 선택해주고 토큰을 생성해야합니다.

# 다시 git push 진행

![image](https://user-images.githubusercontent.com/43658658/157381885-2a05f97c-9b68-4528-b24e-934a44157730.png)

`비밀번호`는 **생성한 토큰**을 복붙합니다.   
![image](https://user-images.githubusercontent.com/43658658/157382043-af8c54c8-0791-4054-96c7-be9970658aeb.png)

정상적으로 Push 되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/157381948-a6f6a648-6193-442b-a10b-7350d50f3605.png)
