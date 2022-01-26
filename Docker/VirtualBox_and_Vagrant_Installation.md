# 버추얼박스(VirtualBox) 설치

아래의 사이트에 접속해서 자신의 OS에 맞는 버전을 다운로드합니다.   
=> https://www.virtualbox.org/wiki/Downloads   
![image](https://user-images.githubusercontent.com/43658658/151104195-ca43c45d-0171-4304-8db2-431e0b9907ba.png)

설치 완료!   
![image](https://user-images.githubusercontent.com/43658658/151104473-5ec8a9f3-3e32-467a-a9c0-5311acd0fc01.png)

# 베이그런트(Vagrant) 설치

베이그런트 : 사용자의 요구에 맞게 시스템 자원을 할당, 배치, 배포해 두었다가 필요할 때 시스템을 사용할 수 있는 상태로 만들어주는(프로비저닝) 코드형 인프라 도구

코드로 인프라를 생성할 수 있게 지원해주는 소프트웨어는 여러 가지가 있지만, 교육용 및 소규모 환경에서는 `베어그런트`가 좋습니다.

아래의 사이트에 접속하여 자신의 OS에 맞는 베이그런트를 다운로드 받습니다.   
=> https://www.vagrantup.com/downloads   
![image](https://user-images.githubusercontent.com/43658658/151104574-a253e87f-a245-4b15-9df1-ee6716140002.png)

설치 완료!   
![image](https://user-images.githubusercontent.com/43658658/151104875-b1b9fafb-9027-4fc4-ba33-2ab60cc98fe4.png)   
- 시스템을 다시 시작합니다.

# 베이그런트 구성 및 테스트

## 가상 이미지 내려받기

`가상 이미지`를 내려받기 위해 베이그런트 클라우드에 접속해서 `sysnet4admin`을 검색합니다.   
=> https://app.vagrantup.com/boxes/search   
![image](https://user-images.githubusercontent.com/43658658/151107154-021a83b3-95d4-4dad-9e25-41651d5fcda5.png)

`sysnet4admin/CentOS-k8s`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/151107200-8c54cd9e-0975-4294-82f7-b516f5a76188.png)

최신 버전을 `c:\HashiCorp` 경로로 내려받습니다.   
![image](https://user-images.githubusercontent.com/43658658/151107347-c21f9d1f-c325-4015-a22a-d376db8771a8.png)

## 프로비저닝 코드 작성

프로비저닝 코드 파일을 생성하기 위해 명령프롬프트(cmd)를 실행합니다.   

베이그런트 설치 경로(c:\HashiCorp)로 이동해 `vagrant init`으로 프로비저닝 기초 파일을 생성합니다.   
```
cd c:\HashiCorp
vagrant init    // 프로비저닝을 위한 기초 파일 생성.
```   
![image](https://user-images.githubusercontent.com/43658658/151105728-5375c19b-1926-461d-a451-8c7ba019dac7.png)

생성된 파일을 `notepad++` 코드 에디터 프로그램을 통해 열어봅니다.   
=> [notepad++ 설치 방법](https://github.com/khyup0629/docker-kubernetes/blob/main/Docker/notepad%2B%2B_installation.md#notepad-%EC%84%A4%EC%B9%98)   
![image](https://user-images.githubusercontent.com/43658658/151106587-07f6bd5f-fb47-45f2-b859-28f68626c046.png)   

`config.vm.box = "base"`라는 내용이 있는지 확인합니다.   
![image](https://user-images.githubusercontent.com/43658658/151106810-cb6ddbe8-ef44-4833-8509-59fcdedbe632.png)   
- 현재 경로(c:\HashiCorp)에 `base`라는 가상 이미지를 버추얼박스의 가상 머신으로 생성하겠다는 의미입니다.

이 내용을 `config.vm.box = "sysnet4admin/CentOS-k8s"`로 변경합니다.   
![image](https://user-images.githubusercontent.com/43658658/151107527-3400d0f0-1fe2-468b-a7db-b0b630778f2b.png)   
- 좀 전에 다운로드 받은 가상 이미지로 변경했습니다.

`vagrant up`으로 `vagrantfile`(프로비저닝 코드 파일)을 읽어들여 프로비저닝을 진행합니다.   
```
vagrant up    // 프로비저닝 파일을 읽어 들여 프로비저닝 진행.
```   
![image](https://user-images.githubusercontent.com/43658658/151107922-e2b2e4bb-4492-44e2-8dca-318af35de0e4.png)

VirtualBox를 실행해서 가상 머신이 제대로 생성되었는지 확인합니다.   
![image](https://user-images.githubusercontent.com/43658658/151108026-7199ae5f-489e-4733-8c5d-bf91c08af410.png)   
- 제대로 생성되었네요!

명령프롬프트(cmd)로 돌아와 `vagrant ssh`를 통해 설치된 CentOS에 접속합니다.   
```
vagrant ssh
```   
![image](https://user-images.githubusercontent.com/43658658/151108250-fd47aa94-3d88-46e3-a0d2-4c3167a5ddcb.png)

CentOS의 실행 시간(`uptime`)과 운영체제의 종류(`cat /etc/redhat-release`)를 확인합니다.   
```
uptime
cat /etc/redhat-release
```   
![image](https://user-images.githubusercontent.com/43658658/151108421-49c0f105-7301-4afa-8332-5e1bde0db0d1.png)

지금까지 베이그런트가 제대로 동작하는지 테스트 해보았습니다.

## 가상 머신 삭제

가상 머신을 삭제하는 방법은 아래와 같습니다.

명령프롬프트(cmd)에서 `vagrant destroy -f`를 명령합니다.   
```
exit    // 가상 머신에 ssh 연결되어 있다면 로그아웃.
vagrant destroy -f    // 베이그런트에서 관리하는 가상 머신을 삭제.
```   
![image](https://user-images.githubusercontent.com/43658658/151108973-4230fe98-a8a6-4cbd-bef8-b46f0a045305.png)   
![image](https://user-images.githubusercontent.com/43658658/151109034-405fccb5-625e-4bf0-a3d8-e253077e09c2.png)

가상 머신이 삭제되었는지 확인합니다.   
![image](https://user-images.githubusercontent.com/43658658/151109052-3c587ae3-1200-4d4f-8527-ba93fd602193.png)   
- 제대로 삭제되었네요!





