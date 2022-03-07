# Git 설치

> <h3>윈도우 설치</h3>

- **(중요!)** 윈도우 `cmd`에서도 깃 명령어를 사용할 수 있도록 해당 옵션을 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/156956482-add95da4-47ad-42e1-8eb1-5c94b34c63b0.png)

나머지 설치 단계는 **모두 기본값**으로 설정하고 설치합니다.

> <h3>우분투 설치</h3>

```
sudo apt-get install -y git
```

# 우분투(사용자 등록)

```
git config --global user.name "<자신의 이름>"
git config --global user.email "<이메일 주소>"
```   
![image](https://user-images.githubusercontent.com/43658658/156956832-0a32caf1-02c8-4b13-bcfd-8ac426dc05d1.png)

# 첫 번째 (윈도우 cmd 실습)

```
mkdir test_git
cd test_git
git init  // 리포지토리를 생성하는 명령어입니다.
```

```
notepad hello.html
```

```
# hello.html
<html>
<body>
 Hello World
</body>
</html>
```

```
dir
```   
![image](https://user-images.githubusercontent.com/43658658/156958123-249ac061-777f-4924-9167-d8d42fce850a.png)

`status` 명령어는 깃 리포지토리 내의 변경 상태를 추적할 수 있습니다.   
```
git status
```   
![image](https://user-images.githubusercontent.com/43658658/156958193-62f2d6e2-7c6b-4003-a6fc-6b0e5cf3b405.png)

작성한 파일을 git에 **추가**합니다.
```
git add <filename>
```   
![image](https://user-images.githubusercontent.com/43658658/156958275-48461042-e1a9-43ec-9ced-71cf1dd17a97.png)

```
git status
```   
![image](https://user-images.githubusercontent.com/43658658/156958305-5c277226-6f40-4dd6-8b18-84cf1faf78fe.png)

추가한 파일을 확정시키기 위해 `commit` 명령어를 활용합니다.   
```
git commit -m "<메시지 입력>"
```   
![image](https://user-images.githubusercontent.com/43658658/156958451-2837cbbf-bdab-492e-a2b2-44e82ee4d9d0.png)

**커밋**까지 완료되었습니다.   
```
git status
```   
![image](https://user-images.githubusercontent.com/43658658/156958690-d32e35cd-faf6-4e38-9432-d3190bdd3705.png)

이로써 첫 번째 버전의 코드가 만들어졌습니다.

# 두 번째 버전

`hello.html` 코드를 수정해보겠습니다.   
```
notepad hello.html
```

```
# hello.html
<html>
<body>
 Hello World Commit 2
</body>
</html>
```

상태를 살펴보면 `hello.html`가 변경되었다는 문구가 나타납니다.   
```
git status
```   
![image](https://user-images.githubusercontent.com/43658658/156959053-5a79a81f-f835-4146-80cd-6760732f31e7.png)

변경된 내용에 대해 다시 **추가**합니다.   
```
git add hello.html
```

```
git status
```   
![image](https://user-images.githubusercontent.com/43658658/156959164-65d044de-5ebc-4948-9837-34d4a7255953.png)

추가한 파일을 커밋합니다.   
```
git commit -m "<메시지 내용>"
```   
![image](https://user-images.githubusercontent.com/43658658/156959237-03bb2405-6bef-46ad-94fc-be4eaf5f3511.png)

# 커밋한 내용 로그 확인

`git log` 명령어를 통해 커밋한 로그를 확인할 수 있습니다.   
```
git log
```   
![image](https://user-images.githubusercontent.com/43658658/156959324-1ef4aaf4-e612-4175-b44f-9f9bb722d4b0.png)

# 브랜치 사용


