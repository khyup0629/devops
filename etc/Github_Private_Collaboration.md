# Github Private으로 협업하기

Github의 Private 레포지토리는 유료 플랜으로 사용 가능했었으나, 이제 무료로 오픈되어 누구나 사용할 수 있게 되었습니다.   
(얼마 전까지 collaborator 3인 등록까지만 무료였었지만 이마저도 풀렸습니다)   
=> [Github Private Repo 무료](https://www.44bits.io/ko/post/news--github-announce-new-price-plan)

따라서, github private 레포지토리를 이용해 협업을 하지 않을 이유가 없어졌습니다.

이 문서에서는 Github Private 레포지토리를 이용한 협업에 대해 몇 가지 실습을 통해 알아보겠습니다.

## 아키텍쳐

1. 각 사용자가 로컬에서 코드 작성 후 브랜치를 생성하여 private 레포지토리로 push
2. push한 버전에 대해 pull request
3. 관리자가 pull request에 대해 검토 후 main 또는 master 브랜치에 merge

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

윈도우에서 git bash를 열고 원하는 폴더로 들어가 `git clone` 명령을 수행합니다.   
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


