# 구글 시트 API 연동하는 법

=> [GCP 홈페이지](https://cloud.google.com/)

`콘솔`로 접근합니다.   
![image](https://user-images.githubusercontent.com/43658658/154221653-2a97a53b-b202-4764-bd6e-1d666377ef13.png)

새 프로젝트를 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/154221724-41dbfa0e-8da2-47b8-9c3e-473059b1179f.png)

`google sheet api`와 `google drive api`를 검색해서 사용을 눌러줍니다.   
![image](https://user-images.githubusercontent.com/43658658/154221795-686a037b-26f8-4993-8336-dbf2fd42f827.png)   
![image](https://user-images.githubusercontent.com/43658658/154221808-d7ff3eff-1e26-4bba-963a-51224d534a69.png)   
![image](https://user-images.githubusercontent.com/43658658/154221826-c8987df3-8a00-4d6d-9822-ec326a622f8d.png)

`사용자 인증 정보 만들기`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/154221855-53272397-5760-4e50-b4fd-a9891bfb0d71.png)

아래와 같이 인증 정보를 만듭니다.   
![image](https://user-images.githubusercontent.com/43658658/154221883-55af3f61-ea35-4e9e-b3a2-9032cf269398.png)   
![image](https://user-images.githubusercontent.com/43658658/154221904-a73cdd38-0ad3-45b4-a341-a4d09ed83cfe.png)   
![image](https://user-images.githubusercontent.com/43658658/154221916-821020f5-fc79-4230-a43c-3d028727c5c3.png)

아래와 같이 `서비스 계정`이 만들어졌습니다.   
![image](https://user-images.githubusercontent.com/43658658/154221986-ca469166-e725-4357-962c-13aab21f341d.png)

**서비스 계정**을 클릭해 접속한 다음 `키 > 키 추가 > 새 키 만들기`를 클릭합니다.   
![image](https://user-images.githubusercontent.com/43658658/154222034-adbf0be6-6fb0-4f48-8689-2d84fc261fe5.png)

`json` 형식으로 만들어줍니다.   
![image](https://user-images.githubusercontent.com/43658658/154222054-b54e4b5a-fa67-4e08-a0bc-425a9acd56d9.png)   
- `.json`파일이 다운로드됩니다.

이제 API를 사용할 구글 시트로 넘어와 우측 상단의 `공유` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154222142-c1262164-88ac-49bc-8f07-b68df0360204.png)

**서비스 계정**을 복사해서 붙여 넣고, `보내기` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154222245-c5123029-707e-4037-a6bb-e8ea31a7f083.png)

파이썬으로 접근해 해당 코드를 통해 API가 작동하는지 테스트합니다.   
![image](https://user-images.githubusercontent.com/43658658/154222328-0bc0e157-e81c-4d96-af33-4ebdeb37a0c7.png)

정상적으로 작동되는 것을 확인합니다.   
![image](https://user-images.githubusercontent.com/43658658/154222374-79ca62dc-ec75-4e4e-8879-2737fa0e32bf.png)
