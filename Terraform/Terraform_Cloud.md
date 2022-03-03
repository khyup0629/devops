# Terraform Cloud

`Organization`과 관련된 메뉴들.   
![image](https://user-images.githubusercontent.com/43658658/156538391-2100c06d-3461-44d4-9ac7-ef7e6ec6c52b.png)   
- `Workspace` : 워크스페이스 관리
- `Registry` : 해당 Organization에 대한 Provider와 Module
- `Settings` : 플랜, 비용 청구서, VCS 설정 등.

## Terraform Cloud Plan & Billing

![image](https://user-images.githubusercontent.com/43658658/156537983-5be515cf-6533-45da-85f3-7fe3355f2f6a.png)

## 실행 모드

워크스페이스에서 `Settings > General`의 설정 중 **Execution Mode**(실행 모드)가 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/156538990-0e025f62-91fb-4950-a8e6-83a006789c96.png)   
- `Remote` : 테라폼 클라우드 인프라를 이용. terraform runner를 이용해 테라폼 코드가 작업자 PC에서 수행되지 않습니다.
- `Local` : 작업자 PC에서 테라폼 코드가 수행됩니다.

