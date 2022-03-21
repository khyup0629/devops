# Error locking state: Error acquiring the state lock

`terraform apply`시 아래의 에러 문구가 발생합니다.   
```
Acquiring state lock. This may take a few moments...
 
Error: Error locking state: Error acquiring the state lock: writing "gs://my/bucket/terraform.tfstate/default.tflock" failed: googleapi: Error 412: Precondition Failed, conditionNotMet
Lock Info:
  ID:        1234567890
  Path:      gs://my/bucket/folder/terraform.tfstate/default.tflock
  Operation: migration destination state
  Who:       mike@machine
  Version:   0.12.12
  Created:   2019-10-30 12:44:36.410366 +0000 UTC
  Info:      
 
 
Terraform acquires a state lock to protect the state from being written
by multiple users at the same time. Please resolve the issue above and try
again. For most commands, you can disable locking with the "-lock=false"
flag, but this is not recommended.
```

## 해결 방법

이 에러는 테라폼의 해당 워크스페이스가 상태 잠금이 걸려 있어서 발생한 에러입니다.

동시에 많은 사용자가 terraform apply를 하는 것을 방지하여 상태 파일의 손상을 막는 역할을 하는 것이 `상태 잠금`입니다.

따라서 해당 ID로의 상태 잠금을 해제한 후, 정상적으로 `apply`를 하면 됩니다.

```
terraform force-unlock [LOCK_ID]
```

위의 에러의 경우에는 아래와 같이 쓸 수 있겠습니다.   
```
terraform force-unlock 1234567890
```
