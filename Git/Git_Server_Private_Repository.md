# Git Server 레포지토리 구축

## 리눅스

Git을 설치합니다.   
```
sudo apt-get install -y git
git --version
```

Git 레포지토리를 하나 생성하고 git으로 초기화합니다.   
```
mkdir -p /opt/git/project.git   // -p : 상위 디렉토리도 함께 생성하는 옵션
git init --bare /opt/git/project.git
```

Git-Shell만을 전용으로 사용할 `git`이라는 사용자를 생성합니다.   
```
useradd -m git   // -m : 전용 홈 디렉토리 생성
passwd git
chown -R git:git /opt/git   // -R : 하위 디렉토리까지 소유자 변경
```

`git` 사용자의 홈 디렉토리로 접근해서 `.ssh` 폴더를 생성합니다.   
```
su root
cd /home/git
mkdir .ssh
```

## 윈도우

`C:/user/사용자이름` 경로에서 git bash를 띄웁니다.

`.ssh` 폴더로 접근해서 SSH 키를 생성합니다.   
```
cd ~/.ssh
ssh-keygen   // 입력하라는 창은 모두 Enter
ls   // id_rsa, id_rsa.pub 파일이 잘 생성되었는지 확인
pwd   // 경로를 메모장에 적어둔다. /c/Users/hongikit/.ssh
```

## Filezilla

`sftp://<ip주소>` / `git` / `비밀번호` 로 연결해서 **public key**를 Git Server 내 `/home/git/.ssh` 디렉토리로 이동시킵니다.   
![image](https://user-images.githubusercontent.com/43658658/157389591-9808ee3c-2063-448d-9c56-b90134554856.png)   
![image](https://user-images.githubusercontent.com/43658658/157389603-f2c2073d-1731-4ba6-bbf1-edc21b8844ee.png)

## 리눅스

가져온 키를 `authorized_keys`라는 파일 내용에 추가합니다.   
(이 과정은 사용자별로 pub키를 받아서   
`id_rsa.<사용자명>.pub >> /home/git/.ssh/authorized_keys` 을 통해 `authorized_keys`에 추가해주어야합니다)   
```
cd /home/git/.ssh
cat id_rsa.pub >> authorized_keys
```

## 윈도우

`git clone`을 할 적당한 폴더로 이동합니다.

```
git clone ssh://git@<ip주소>:/opt/git/project.git
```

`.git` 폴더로 접근하면 해당 내용이 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/157389889-fef908fe-d666-41b8-86bc-ae095c47c589.png)

이제 로컬에서 파일을 생성 또는 수정하고 추가 및 커밋, 푸시할 수 있습니다.   
```
touch test.txt
git add .
git commit -m "New test.txt file"
git push origin master
```

## git 계정 접근 막기(리포지토리 보호 가능)

신규로 추가한 `git` 계정은 오직 Git 저장소를 관리하는 목적으로만 사용되어야 하므로,   
사용자 계정마다 자동으로 지정되는 bash-shell에서 git 명령어만 사용할 수 있게 해주는 **git-shell**로 바꿔주면 됩니다.

**Git Server**에서 진행합니다.   
```
which git-shell
chsh git -s /usr/bin/git-shell
cd /home/git
mkdir git-shell-commands
chown git:git /home/git/git-shell-commands
cat /etc/passwd | grep git    // git 사용자가 /usr/bin/git-shell 을 쓰는지 확인
```

정상적으로 적용되었는지 확인해봅시다.   
```
su git
git> 이 뜨면 작업 성공
```
