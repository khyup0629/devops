# SSH Agent

`SSH Agent` : 인스턴스에 접근할 때 password와 private_key를 미리 등록해서 이후 서버에 접근할 때 해당 항목을 요구하지 않도록 하는 역할 수행.

- 코드 상 기밀 데이터가 남지 않아 **보안이 우수**합니다.   
(일반적으로 SSH로 인스턴스에 접근하려면 코드에 비밀번호와 인증 키에 대한 정보가 명시되어야 하기 때문입니다)

운영체제에 인증 키를 등록해주는 과정이 필요합니다.

=> [SSH Agent on Windows 참고 사이트](https://docs.microsoft.com/ko-kr/windows-server/administration/openssh/openssh_keymanagement)



