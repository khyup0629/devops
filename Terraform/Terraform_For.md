# For 문

=> [Terraform For 문 사용법](https://www.terraform.io/language/expressions/for)

아래와 같은 for문이 있다고 합시다.   
```
[for k, v in var.map : length(k) + length(v)]
```

`var.map`은 딕셔너리 형태입니다.
만약 var.map = {"abc" = "a", "abcd" = "abc"} 라는 key-value가 들어있다면, 

위 for문의 출력 값은 `[4, 7]`이 됩니다.   
- `abc`는 `k`이고 길이는 `3`입니다. `a`는 `v`이고 길이는 `1`입니다. 따라서 `"abc" = "a"`는 `4`라는 결과값을 갖습니다.
- `abcd`는 `k`이고 길이는 `4`입니다. `abc`는 `v`이고 길이는 `3`입니다. 따라서 `"abcd" = "abc"`는 `7`이라는 결과값을 갖습니다.

