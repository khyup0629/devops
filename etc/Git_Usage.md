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

- 여러 사람이 협업해야 할 때 충돌을 방지하기 위해서는 **브랜치**가 필요합니다.   
![image](https://user-images.githubusercontent.com/43658658/156960155-b5db88bc-0033-4ff4-9639-cbda9631104c.png)

관리자는 브랜치들을 **적절히 병합(merge)** 하고 **퀄리티**와 **안정성**을 관리해야 합니다.

현재 브랜치 목록을 살펴봅시다.   
```
git branch
```   
![image](https://user-images.githubusercontent.com/43658658/156960569-e37b7d64-52a7-4d44-a5e8-4dad06ad3904.png)

뒤에 아규먼트를 붙여주게 되면 그 아규먼트를 이름으로 한 브랜치가 생성됩니다.   
```
git branch test1
```   

브랜치 목록을 살펴보면 `test1`이 추가된 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/156960616-913342f4-7b0b-437e-aad7-54b011b27432.png)

`*`는 현재 위치한 브랜치를 의미합니다. 브랜치를 이동하기 위해서는 `checkout` 명령어를 활용합니다.   
```
git checkout test1
```   

현재 브랜치가 `test1`로 옮겨갑니다.   
![image](https://user-images.githubusercontent.com/43658658/156960642-eaafd53f-4c59-43ea-8bba-8056f608fc3c.png)

`test1` 브랜치에서 `hello.html` 내용을 변경해봅니다.   
```
# hello.html
<html>
<body>
 Hello World Commit 2
 Test Branch
</body>
</html>
```

```
git status
```

변경한 파일을 추가하고 커밋합니다.   
```
git add hello.html
git commit -m "Branch test1"
```

다시 `master` 브랜치로 돌아옵니다.   
```
git checkout master
```

`hello.html` 파일을 열면 `test1` 브랜치에서 수정했던 파일 내용 이전의 내용이 나타납니다.   
```
notepad hello.html
```   
![image](https://user-images.githubusercontent.com/43658658/156999924-ec4d530f-c45a-4b29-b85b-e22a4544c593.png)

`master` 브랜치에서 `test1` 브랜치의 내용을 병합해보겠습니다.   
```
git merge test1
```   
![image](https://user-images.githubusercontent.com/43658658/157000367-75ef4ea7-2e6f-45bb-898f-95b4b0a7b4e0.png)

`hello.html` 파일의 내용을 확인해보면, `test1`에서 수정했던 내용이 반영된 것을 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/157000347-de86c358-a4f4-4610-ab2d-1a7b770e9deb.png)

`-d` 옵션을 주어 브랜치를 삭제할 수 있습니다.   
```
git branch -d test1
```

# 병합에서 동시성 이슈를 해결하는 방법

```
notepad hello.html
```

```
# hello.html
<html>
<body>
</body>
</html>
```

```
git add hello.html
git commit -mm "Updated hello.html"
git status
```

```
git branch Test_Branch
git checkout Test_Branch
notepad hello.html
```

```
# hello.html
<html>
<body>
Edit in Test_Branch
</body>
</html>
```

```
git add hello.html
git commit -m "Updated hello.html"
git status
```

```
git checkout master
notepad hello.html
```

```
# hello.html
<html>
<body>
Edit in Master Branch
</body>
</html>
```

```
git add hello.html
git commit -m "Edit in Master Branch"
```

현재 merge 하기 전 두 브랜치에서 `hello.html` 파일에 대한 수정을 거쳤습니다.   
이대로 Test_Branch 브랜치를 master 브랜치에 merge하게 되면 아래와 같은 현상이 발생합니다.   
```
git merge Test_Branch
```   
![image](https://user-images.githubusercontent.com/43658658/157003152-b54ec6b6-271d-47dd-8eb9-f6af0b77f04c.png)

상태를 보면 아래와 같이 `both modified` 문구가 나타납니다.
```
git status
```   
![image](https://user-images.githubusercontent.com/43658658/157003288-ea5118f2-05aa-48a8-a256-e2c0589149d3.png)

`hello.html` 파일을 살펴보면 아래와 같이 어떤 브랜치에서 어떻게 수정되었는지가 나타납니다.   
```
notepad hello.html
```   
![image](https://user-images.githubusercontent.com/43658658/157017921-2f0fa889-7f53-4d45-ab6b-384780439260.png)

여기서 각자 수정한 코드 중 필요한 부분만 빼서 수정합니다.   
```
# hello.html
<html>
<body>
Edit in Master Branch
Edit in Test_Branch
</body>
</html>
```

내용이 수정되었으니 다시 추가, 커밋합니다.   
```
git add hello.html
git commit -m "Final hello.html"
```   

`hello.html` 파일을 열어보면 수정된 내용이 반영되어 있는 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/157018566-bb9a300f-3290-48f1-900f-6c4105cda6b1.png)

## gitk

UI 있는 프로그램으로 로그를 직관적으로 보고 싶으면 `gitk` 명령어를 입력합니다.   
```
gitk
```   

응용 프로그램이 하나 띄워집니다.   
![image](https://user-images.githubusercontent.com/43658658/157020697-262431cb-6743-40b3-9c3c-c42a8367028c.png)

## 원격 저장소(Github) Push

깃허브라는 원격 저장소에 각 로컬에서 Pull, Push하는 구조입니다.   
![image](https://user-images.githubusercontent.com/43658658/157019238-ce9d66c1-907b-4e76-a519-41800fa3d921.png)

깃허브에 접속해서 리포지토리를 하나 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/157023063-e3a533c4-f0b8-46ed-bae0-5fca8a5d6ad5.png)   
- 라이센스의 경우 구글링을 통해 라이센스에 대한 정확한 정보를 찾아본 뒤 이 리포지토리에 맞는 라이센스를 선택해야 합니다.

주소를 복사합니다.   
![image](https://user-images.githubusercontent.com/43658658/157023371-503b3f0a-6306-49f1-b49e-a54e6397f24b.png)

원격 저장소를 로컬에 디렉토리로 가져옵니다.   
```
git clone <리포지토리 URL>
```

`Git_Test`라는 폴더가 하나 생성됩니다. 이 폴더가 깃허브에서 가져온 리포지토리입니다.   
![image](https://user-images.githubusercontent.com/43658658/157023540-ff7da78e-5f9b-4596-bf1f-0fe7c3ef3d11.png)

가져온 리포지토리로 접근해서 README.md 파일을 수정합니다.   
```
cd Git_Test
notepad README.md
```

```
# README.md
# Git_Test

## 원격저장소      <-- 해당 내용을 추가
```

새 파일을 하나 만듭니다.   
```
notepad hello.md
```

```
# hello.md
<html>
<body>
</body>
</html>
```

```
git status
```   
![image](https://user-images.githubusercontent.com/43658658/157024257-e519a90e-f31b-49d8-8712-0f4b1cc1faa5.png)

2개 이상의 변동 사항에 대해 `*`를 통해 모두 추가할 수 있습니다.
```
git add *
git commit -m "hello.html 파일이 추가 되었습니다."
```

위 추가, 커밋은 로컬에서만 된 것입니다. 깃허브로 push를 해주어야 합니다.   
```
git push
```

깃허브에 수정한 내용과 추가한 파일이 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/157025350-def2c64c-ab54-4db7-a742-52aa3500db01.png)

## Github Pull Request(PR)

다수의 개발자가 협업할 때 사용하는 방법입니다.   

**<Pull Request 전체 아키텍처>**   
![image](https://user-images.githubusercontent.com/43658658/157028510-06c75586-a195-4c01-9fd9-bf6b737d97b0.png)

1. 공유하길 원하는 리포지토리로 들어가서 `Fork` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/157028823-b67058c0-73e7-4bec-9382-d1265ba7e9a1.png)   
- 그럼 현재 자신의 계정에 사본 리포지토리가 만들어집니다.
2. 사본 리포지토리 URL을 이용해 `git clone`을 수행합니다.
3. 가져온 리포지토리 디렉토리로 접근해 파일을 추가/변경합니다.
4. `git add *`, `git commit -m `, `git push`를 수행합니다.
5. `New Pull Request` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/157029853-ab7aad2a-af9f-45b5-8472-1f1e8de5d6e8.png)   
- Request 제목과 내용을 입력하고 `Create pull request` 버튼을 누릅니다.

6. 원본 리포지토리에 `Pull requests` 탭에 요청사항이 와 있습니다.

- `Merge`하고 싶다면, `Merge pull request` > `Confirm Merge`
- 마음에 들지 않으면 `Reject`합니다.

원본 리포지토리에 사본 리포지토리의 내용이 반영됩니다.



