# AWS CLI 기본 명령어

`aws` 명령어는 다음과 같은 구조를 가집니다. 

```
aws <command> <subcommand> <options or parameters>'
```

## version

```
hyeob@hyeob:~/01-start$ aws --version
aws-cli/2.2.16 Python/3.8.8 Linux/5.4.0-99-generic exe/x86_64.ubuntu.20 prompt/off
```

## help

```
aws help    // aws 명령어 자체에 대한 메뉴얼 출력
aws <command> help     // <command>에 대한 메뉴얼 출력
aws <command> <subcommand> help     // <command> <subcommand>에 대한 메뉴얼 출력
```
