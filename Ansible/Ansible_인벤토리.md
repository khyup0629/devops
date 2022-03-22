# 인벤토리

- `인벤토리` : 대상 서버 호스트를 관리하는 파일

- **그룹 기능** 지원
  - 서버 군을 **프로덕션 레벨**에 따라
  - 우분투, 아마존 그룹과 같이 **운영체제**에 따라서 나누기도 한다.

- `Static Inventory(정적 인벤토리)`
- `Dynamic Inventory(동적 인벤토리)` : **AWS**와 같은 클라우드에서 **Auto Scaling**과 같은 기능을 활용할 때

## 정적 인벤토리

인벤토리 파일을 만들고 그 안에 `IP 주소`, `dns`를 적습니다.   
(인벤토리 파일은 딱히 확장자 명이 있는 건 아니고, 임의로 붙여서 사용할 수 있습니다)   
![image](https://user-images.githubusercontent.com/43658658/159396205-0ac004b8-80e2-4348-be31-56feada05181.png)

파일의 ip 주소는 `terraform output`을 통해서 확인할 수도 있고, 직접 `AWS 콘솔`에 접근해서 확인할 수도 있습니다.

```
# amazon.inv
13.209.11.129
3.36.58.47
```

```
# ubuntu.inv
ec2-3-34-135-32.ap-northeast-2.compute.amazonaws.com
ec2-52-79-202-181.ap-northeast-2.compute.amazonaws.com
```

`[`, `]`를 사용해서 그룹을 만들어 줄 수도 있습니다.   

```
# simple.inv
[amazon]
13.209.11.129
3.36.58.47
[ubuntu]
ec2-3-34-135-32.ap-northeast-2.compute.amazonaws.com
ec2-52-79-202-181.ap-northeast-2.compute.amazonaws.com
```

`[all]`이라는 기본 그룹은 인벤토리에 정의되어 있는 모든 주소를 포함하고 있습니다.

`alias(별칭)` 기능을 사용할 수도 있습니다.   
형식은 `<별칭> ansible_host=<ip 주소 or dns>`입니다.   
```
# alias.inv
[amazon]
amazon1 ansible_host=13.209.11.129
amazon2 ansible_host=3.36.58.47

[ubuntu]
ubuntu1 ansible_host=ec2-3-34-135-32.ap-northeast-2.compute.amazonaws.com
ubuntu2 ansible_host=ec2-52-79-202-181.ap-northeast-2.compute.amazonaws.com
```

`ansible_user`를 통해 인스턴스의 사용자 정보까지 적어줄 수 있습니다.

```
# vars.inv
[amazon]
amazon1 ansible_host=13.209.11.129 ansible_user=ec2-user
amazon2 ansible_host=3.36.58.47 ansible_user=ec2-user

[ubuntu]
ubuntu1 ansible_host=ec2-3-34-135-32.ap-northeast-2.compute.amazonaws.com ansible_user=ubuntu
ubuntu2 ansible_host=ec2-52-79-202-181.ap-northeast-2.compute.amazonaws.com ansible_user=ubuntu

# 하위 그룹 기능 : [그룹명:children] 밑에는 하위 그룹 대상을 써줍니다.
[linux:children]
amazon
ubuntu
```


