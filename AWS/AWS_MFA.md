# MFA 설정 방법

이번에는 MFA에서 **Google OTP**를 설정하는 방법을 알아보도록 하겠습니다.   

`보안 자격 증명`으로 접속합니다.   
![image](https://user-images.githubusercontent.com/43658658/155908979-ad8348e2-080a-4d60-8dbb-0f322ef97d28.png)

`멀티 팩터 인증(MFA) > MFA 활성화`를 선택합니다.   
![image](https://user-images.githubusercontent.com/43658658/155909181-48de80d1-b7e7-4233-b072-6a05c282a20b.png)

`가상 MFA 디바이스`를 선택하고 **[계속]** 버튼을 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/155909197-706c6fa3-5a62-4874-b5aa-b5886efe9db2.png)

아래의 단계로 넘어갑니다.   
![image](https://user-images.githubusercontent.com/43658658/155909464-2064db3e-f3a5-4347-a774-6851ae8a2baa.png)

휴대폰에서 `Google OTP` 어플을 설치합니다.

어플을 실행하고 우측 하단의 `+` 버튼을 클릭, `QR 코드 스캔`을 선택합니다.

`AWS 콘솔`의 MFA 설정 화면에서 `QR 코드 표시`를 클릭하고 휴대폰을 이용해 **QR 코드를 스캔**합니다.

그럼 Google OTP에 현재 AWS 계정이 등록됩니다.

주기적으로 갱신되는 **OTP 6자리**를 연속으로 입력합니다.   
![image](https://user-images.githubusercontent.com/43658658/155909629-12400ed8-bc55-41d5-acb5-8dacaad5b5f3.png)

**MFA**가 할당되었습니다. 이제 로그인 시 **MFA를 인증하는 과정**을 거치게 됩니다.   
![image](https://user-images.githubusercontent.com/43658658/155909737-9d1b0445-779a-435c-94df-931816922b18.png)
