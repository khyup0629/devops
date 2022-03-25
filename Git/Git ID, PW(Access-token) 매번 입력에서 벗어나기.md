# Git ID/PW(Access-token) 매번 입력에서 벗어나기

Push를 할 경우 매번 username, password를 입력해줘야 실행이 가능한데,

자격 증명 정보를 캐싱할 수 있도록 저장해 매번 자격증명을 입력하는 번거로움을 없앨 수 있습니다.

### 자격 증명을 반영구 저장하는 방식

먼저 push를 이용해 `username`과 `password(token)`을 한 번 입력한 경우가 있어야 합니다.
![image](https://user-images.githubusercontent.com/43658658/160055785-a7114fca-dbaf-40dc-b679-de181fdd8475.png)

그럼 자격 증명이 남아있게 되고, 이를 로컬에 저장합니다.

```
git config --unset credential.helper
git config credential.helper store
```

저장된 데이터는 `~/.git-credentials`에 저장됩니다.   
![image](https://user-images.githubusercontent.com/43658658/160055682-76c163fb-cd6e-4157-ba8d-d7555612d81c.png)


### 자격 증명을 특정 시간동안 git cache에 임시로 저장하는 방식

마찬가지로 push를 이용해 `username`과 `password(token)`을 한 번 입력한 경우가 있어야 합니다.
![image](https://user-images.githubusercontent.com/43658658/160055785-a7114fca-dbaf-40dc-b679-de181fdd8475.png)

```
git config --unset credential.helper
git conofig credential.helper cache
git config credential.helper 'cache --timeout 7200'  // 초단위, default: 900s
```

`7200`초 동안만 자격 증명이 유지됩니다.

