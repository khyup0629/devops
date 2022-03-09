# Github Private으로 협업하기

Github의 Private 레포지토리는 유료 플랜으로 사용 가능했었으나, 이제 무료로 오픈되어 누구나 사용할 수 있게 되었습니다.   
(얼마 전까지 collaborator 3인 등록까지만 무료였었지만 이마저도 풀렸습니다)   
=> [Github Private Repo 무료](https://www.44bits.io/ko/post/news--github-announce-new-price-plan)

따라서, github private 레포지토리를 이용해 협업을 하지 않을 이유가 없어졌습니다.

이 문서에서는 Github Private 레포지토리를 이용한 협업에 대해 몇 가지 실습을 통해 알아보겠습니다.

## 아키텍쳐

![image](https://user-images.githubusercontent.com/43658658/157387768-cf64e075-fb89-4633-9936-15b9e30013d5.png)   
1. 각 사용자가 로컬에서 코드 작성 후 브랜치(User1, User2, User3)를 생성하여 Private 레포지토리로 **Push**
2. 각 사용자는 Github에서 **Push**한 브랜치에 대해 **Pull Request**
3. 관리자가 **Pull Request**에 대해 검토 후 **main** 또는 **master** 브랜치에 **Merge**

## 협업에서의 유의사항

협업을 할 때는 **반드시** 아래의 조건을 지켜줘야 합니다.

1. 모든 협업자는 **main 또는 master 브랜치**로 절대 Push하지 말 것!
2. 로컬에서 **자신만의 브랜치를 생성**한 후 브랜치를 Push 할 것!
3. Pull Request를 받은 관리자는 Merge 후 **반드시 브랜치를 지울 것**!
4. 관리자를 제외한 **개발자는 Merge를 건드리지 말 것**!

## Priavte 레포지토리 생성

Github에서 Private 레포지토리를 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/157352669-a6da2ebf-9f4d-4ebb-98ac-539389047f6e.png)   
![image](https://user-images.githubusercontent.com/43658658/157352792-b5e0fb4c-4b05-4ab0-9197-3e88e5b68993.png)

## git clone(윈도우 기준)

윈도우에서 Git bash를 열고 원하는 폴더로 들어가 `git clone` 명령을 수행합니다.   
```
git clone <레포지토리 URL>
```

`레포지토리 URL`은 레포지토리에서 확인 가능합니다.   
![image](https://user-images.githubusercontent.com/43658658/157353009-318ad3b1-b09d-4b62-88dc-a1a88330b4ad.png)

## Collaborator

**Private 레포지토리**는 아무나 접근할 수 없습니다.

특정 사용자가 접근하도록 허용하고 싶다면 `Settings > Collaborator` 탭으로 들어가 해당 사용자에 대해 등록을 해주어야 합니다.   
![image](https://user-images.githubusercontent.com/43658658/157353384-a926835f-30fa-42f6-85ee-0f6aeeb97683.png)

사용자의 이름 또는 이메일로 등록할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/157353430-1fa830ba-b1e4-4275-a9d3-f63a0e5da3b0.png)

로컬 사용자에서 Git bash에 등록된 이름 또는 이메일이 궁금할 경우 아래의 명령을 통해 확인 가능합니다.   
```
git config --list
```   
![image](https://user-images.githubusercontent.com/43658658/157353719-e1d19daa-661b-46d9-b102-d4d217874ae9.png)

만약 해당 항목이 없다면 직접 Git bash에 이름과 이메일을 환경 변수로 등록할 수도 있습니다.   
```
git config --global user.name "<사용자이름>"
git config --global user.email "<이메일주소>"
```

## 코드 수정 후 Github로 Push(개발자)

먼저 브랜치를 생성하고 그 안에서 작업합니다.   
```
git checkout -b hyeob
```

기존의 `README.md` 파일을 변경해보겠습니다.   
```
vim README.md
```

```
# README.md
# test

## hyeob 브랜치에서 수정한 내용입니다.
```

변경한 파일에 대해 추가, 커밋합니다.   
```
git add .
git commit -m "hyeob README.md 파일 변경"
```

Private 레포지토리에 현재 브랜치의 내용을 Push합니다.   
```
git push origin hyeob
```

Private 레포지토리로 접근하면 `hyeob` 브랜치가 생성되고 수정된 코드가 Push 된 것을 볼 수 있습니다.
![image](https://user-images.githubusercontent.com/43658658/157355755-ca34ea24-9477-4871-be5e-54374e6e778f.png)

## Pull Request(개발자)

자신이 Push한 코드에 대해 Pull Request를 통해 관리자에게 Merge 검토를 요청합니다.   
![image](https://user-images.githubusercontent.com/43658658/157355836-670235a2-9c8a-44c9-866b-7b6b5856df94.png)

제목과 내용을 작성한 후 `Create pull request` 버튼을 눌러 Pull Request 합니다.   
![image](https://user-images.githubusercontent.com/43658658/157355973-0b407bf1-664d-4536-8ce5-a540915be9ba.png)

Pull Request를 하게 되면 Private 레포지토리의 특성상 **모두에게 Merge가 가능한 권한**이 주어져 있습니다.   

#### 하지만, 원활한 프로젝트 관리를 위해 절대 관리자 이외에는 Merge를 건드리지 않도록 주의합니다!

## 검토 후 Merge(관리자)

관리자는 `Pull Request` 탭에서 개발자로부터 온 Pull Request들을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/157356183-635b1abd-82f4-4c63-a210-c132b5640ba5.png)

`Commits` 탭을 통해 커밋 내용을 볼 수 있고,   
![image](https://user-images.githubusercontent.com/43658658/157356309-b6be1650-980c-4ff0-976c-ae4d3647619e.png)

해당 커밋을 클릭해서 수정된 코드의 내용을 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/157356331-06875b3f-09f3-46eb-9ecd-fe0b5c312aed.png)

검토 후 문제가 없다고 판단되면 `Merge pull request` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/157356379-b377c510-69cd-4793-bfcc-e49ced78ff24.png)

다시 한 번 `Confirm merge` 버튼을 눌러서 적용합니다.   
![image](https://user-images.githubusercontent.com/43658658/157356433-80e39771-4762-4f72-a617-3f7654e37d01.png)

Merge가 완료되었습니다. 해당 Pull request에 사용된 브랜치는 지우도록 합니다.   
![image](https://user-images.githubusercontent.com/43658658/157356524-24ed8a29-63a0-4100-95f8-c194c3dd28c2.png)

main 브랜치를 보면 hyeob 브랜치에서 수정한 내용이 merge 되어 나타난 것을 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/157356605-6b5ed426-0e3d-4ffb-aab1-05e8dbe3a6b0.png)

## 이전 버전으로 되돌아가기(개발자)

개발자가 개발을 하다보면 여러 문제로 코드를 롤백하고 싶을 때가 있습니다.   

이럴 때 `reset` 또는 `revert` 명령어를 이용하는데, 만약 원격 레포지토리에 한 번이라도 push를 했다면 `revert` 명령어만 가능합니다.

현재 위의 실습에서 다시 한 번 `README.md` 파일이 수정되어 아래와 같이 main 브랜치에 merge된 상태입니다.
![image](https://user-images.githubusercontent.com/43658658/157357036-70356027-b0d3-4150-a0a7-4b534e0e09a2.png)

`나 이전 코드로 돌아갈래` 문구가 사라진 이전 버전의 코드로 되돌아가고 싶습니다.   
![image](https://user-images.githubusercontent.com/43658658/157357153-69ff4e43-7e8b-48ea-83f2-1f8b1e090482.png)

Git bash에서 `git log` 명령어를 수행합니다.   
```
git log
```   

자신이 커밋한 이력(위쪽이 최신)이 나타납니다. 여기서 두 번째 커밋한 내용으로 되돌아가고 싶습니다.   
![image](https://user-images.githubusercontent.com/43658658/157357331-a43f623e-9eab-47ff-ab82-be3ba214428f.png)

이때 유의할 점은 내가 되돌아가고 싶은 커밋의 위쪽 버전을 선택해야 한다는 것입니다.   
![image](https://user-images.githubusercontent.com/43658658/157357434-be385812-3e33-4822-89b4-cda3a57b121a.png)

커밋 고유 id의 앞에 8자리 정도만 입력해서 `git revert` 명령어를 수행합니다.   
```
git revert 705bc12e
```   
![image](https://user-images.githubusercontent.com/43658658/157357548-e07a16cb-dfa4-4961-b9ac-ad6a5aeaf227.png)

엔터를 누르면 아래의 편집기가 나타나는데, 커밋 메시지를 적어줍니다.   
![image](https://user-images.githubusercontent.com/43658658/157357712-b5482947-6616-45f2-bf50-27178feb83b3.png)

엔터를 누르면 롤백이 완료됩니다.

커밋이 모두 완료된 상태이기 때문에 Push 명령만 다시 수행합니다.   
```
git push origin hyeob
```

Private 레포지토리에는 롤백된 버전의 코드가 브랜치로 생성됩니다.
![image](https://user-images.githubusercontent.com/43658658/157357983-f5d1a7e6-16b5-4b4e-8e94-d3bb893385aa.png)

Pull Request 후 Merge하면 main 브랜치의 코드가 이전 버전으로 되돌아갑니다.   
![image](https://user-images.githubusercontent.com/43658658/157358124-568effab-a65b-478f-8f55-9c8595737cf7.png)

## 동시성 이슈 해결(관리자)

만약 `A`라는 같은 버전의 소스로 `user1`과 `user2`가 각각 `B`와 `C`라는 코드로 변경해 Merge를 하려고 한다면 `Conflict` 문제가 발생합니다.

예를 들어 아래 내용의 `README.md` 파일을 가지고   
```
# test

## hyeob 브랜치에서 수정한 내용입니다.
```

`hyeob` 브랜치에서는 아래와 같은 내용을 추가하고,
```
# test

## hyeob 브랜치에서 수정한 내용입니다.

## hyeob 브랜치에서 추가한 내용
```

`yun` 브랜치에서는 아래의 내용을 추가한 뒤,
```
# test

## hyeob 브랜치에서 수정한 내용입니다.

## yun 브랜치에서 추가한 내용
```

main 브랜치로 merge 하게 되면 아래와 같이 충돌 현상이 발생합니다.   
![image](https://user-images.githubusercontent.com/43658658/157358724-e610d0d0-811b-4897-a986-7fd90cec6869.png)

`Resolve conflicts` 버튼을 눌러보면 아래와 같이 어느 부분에서 브랜치끼리의 충돌이 발생했는지 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/157358812-51041774-a34e-4282-bf60-cbde99b8ca5f.png)

만약 두 브랜치에서 추가한 내용을 모두 쓰고 싶다면 여기서 코드를 편집한 뒤 `Mark as resolved` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/157358916-89f4e2dd-f1dd-434c-bf1d-e7e38fce1372.png)

`Commit merge` 버튼이 나타납니다. 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/157358966-73af73f4-8414-4b8c-939b-4ff63bd9580c.png)

이제 정상적으로 Merge 할 수 있게 되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/157359057-5e30e813-0ee8-48c7-97b1-84c263172a2b.png)

Merge를 완료하면 main 브랜치는 충돌을 해결한 내용의 코드로 나타난 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/157359103-80f6867b-3ee1-4898-83ad-366a84df39fe.png)

