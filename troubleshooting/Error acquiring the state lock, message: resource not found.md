# Error acquiring the state lock, message: resource not found

`terraform apply` 시 아래의 에러가 발생하였습니다.   
![image](https://user-images.githubusercontent.com/43658658/159256210-96325292-dfb5-4496-b4dd-f1668d8c3fa6.png)

테라폼 클라우드의 locking은 풀려져 있는 상태였습니다.   
![image](https://user-images.githubusercontent.com/43658658/159256320-da2717bd-9a21-4508-9e70-796228d964ae.png)

## 해결 방법

본 에러는 `AWS CLI` 상에서 자격 증명을 바꿔 사용자를 바꾼 상태에서 `Terraform Cloud`의 `사용자 `API Token`을 갱신하지 않아서 발생한 문제였습니다.

우측 상단의 계정 탭에서 `User settings`로 접근합니다.   
![image](https://user-images.githubusercontent.com/43658658/159256574-5198d5a4-4cbc-4587-885d-73fc047e6b92.png)

토근을 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/159256629-ee10a68b-d49a-46bc-a673-e6e9ce57c0f7.png)

토큰을 복사하여 `~/.terraformrc` 파일에 붙여넣습니다.   
```
vim ~/.terraformrc
```   
![image](https://user-images.githubusercontent.com/43658658/159256797-13b0783b-98aa-4cd3-ba3a-4742d93d7503.png)

이렇게 설정한 후, `terraform apply`를 수행하면 정상적으로 수행이 됩니다.
