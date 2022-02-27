# AWS CLI 디버그 모드 활성화

해당 커멘드에 대해 호출되는 디버그 메시지들을 출력합니다.   
```
aws <command> <subcommand> --debug
```

예를 들어, `aws sts get-caller-identity` 명령어를 디버그 모드로 실행하면 아래와 같습니다.   
```
hyeob@hyeob:~/01-start$ aws sts get-caller-identity --debug
2022-02-27 06:06:41,816 - MainThread - awscli.clidriver - DEBUG - CLI version: aws-cli/2.2.16 Python/3.8.8 Linux/5.4.0-99-generic exe/x86_64.ubuntu.20
2022-02-27 06:06:41,817 - MainThread - awscli.clidriver - DEBUG - Arguments entered to CLI: ['sts', 'get-caller-identity', '--debug']
2022-02-27 06:06:41,837 - MainThread - botocore.hooks - DEBUG - Event building-command-table.main: calling handler <function add_s3 at 0x7f03b4dd7790>
2022-02-27 06:06:41,837 - MainThread - botocore.hooks - DEBUG - Event building-command-table.main: calling handler <function add_ddb at 0x7f03b4f73280>
2022-02-27 06:06:41,838 - MainThread - botocore.hooks - DEBUG - Event building-command-table.main: calling handler <bound method BasicCommand.add_command of <class 'awscli.customizations.configure.configure.ConfigureCommand'>>
2022-02-27 06:06:41,838 - MainThread - botocore.hooks - DEBUG - Event building-command-table.main: calling handler <function change_name at 0x7f03b4fbdc10>
2022-02-27 06:06:41,838 - MainThread - botocore.hooks - DEBUG - Event building-command-table.main: calling handler <function change_name at 0x7f03b4fc5a60>
2022-02-27 06:06:41,838 - MainThread - botocore.hooks - DEBUG - Event building-command-table.main: calling handler <function alias_opsworks_cm at 0x7f03b4dea1f0>
2022-02-27 06:06:41,839 - MainThread - botocore.hooks - DEBUG - Event building-command-table.main: calling handler <function add_history_commands at 0x7f03b4f620d0>
2022-02-27 06:06:41,839 - MainThread - botocore.hooks - DEBUG - Event building-command-table.main: calling handler <bound method BasicCommand.add_command of <class 'awscli.customizations.devcommands.CLIDevCommand'>>
2022-02-27 06:06:41,839 - MainThread - botocore.hooks - DEBUG - Event building-command-table.main: calling handler <function add_waiters at 0x7f03b4de1430>
2022-02-27 06:06:41,839 - MainThread - botocore.loaders - DEBUG - Loading JSON file: /usr/local/aws-cli/v2/2.2.16/dist/awscli/data/cli.json
2022-02-27 06:06:41,844 - MainThread - botocore.hooks - DEBUG - Event top-level-args-parsed: calling handler <function resolve_types at 0x7f03b4e92310>
2022-02-27 06:06:41,844 - MainThread - botocore.hooks - DEBUG - Event top-level-args-parsed: calling handler <function no_sign_request at 0x7f03b4e92e50>
2022-02-27 06:06:41,844 - MainThread - botocore.hooks - DEBUG - Event top-level-args-parsed: calling handler <function resolve_verify_ssl at 0x7f03b4e92dc0>
2022-02-27 06:06:41,844 - MainThread - botocore.hooks - DEBUG - Event top-level-args-parsed: calling handler <function resolve_cli_read_timeout at 0x7f03b4e92f70>
2022-02-27 06:06:41,845 - MainThread - botocore.hooks - DEBUG - Event top-level-args-parsed: calling handler <function resolve_cli_connect_timeout at 0x7f03b4e92ee0>
2022-02-27 06:06:41,845 - MainThread - botocore.hooks - DEBUG - Event top-level-args-parsed: calling handler <built-in method update of dict object at 0x7f03b4cfea80>
2022-02-27 06:06:41,845 - MainThread - awscli.clidriver - DEBUG - CLI version: aws-cli/2.2.16 Python/3.8.8 Linux/5.4.0-99-generic exe/x86_64.ubuntu.20 prompt/off
2022-02-27 06:06:41,846 - MainThread - awscli.clidriver - DEBUG - Arguments entered to CLI: ['sts', 'get-caller-identity', '--debug']
2022-02-27 06:06:41,846 - MainThread - botocore.hooks - DEBUG - Event session-initialized: calling handler <function add_timestamp_parser at 0x7f03b4dd7dc0>
2022-02-27 06:06:41,846 - MainThread - botocore.hooks - DEBUG - Event session-initialized: calling handler <function register_uri_param_handler at 0x7f03b5879d30>
2022-02-27 06:06:41,846 - MainThread - botocore.hooks - DEBUG - Event session-initialized: calling handler <function add_binary_formatter at 0x7f03b4d45ca0>
2022-02-27 06:06:41,847 - MainThread - botocore.hooks - DEBUG - Event session-initialized: calling handler <function no_pager_handler at 0x7f03b58761f0>
2022-02-27 06:06:41,847 - MainThread - botocore.hooks - DEBUG - Event session-initialized: calling handler <function inject_assume_role_provider_cache at 0x7f03b57dc9d0>
2022-02-27 06:06:41,848 - MainThread - botocore.utils - DEBUG - IMDS ENDPOINT: http://169.254.169.254/
2022-02-27 06:06:41,850 - MainThread - botocore.hooks - DEBUG - Event session-initialized: calling handler <function attach_history_handler at 0x7f03b4f5ef70>
2022-02-27 06:06:41,850 - MainThread - botocore.hooks - DEBUG - Event session-initialized: calling handler <function inject_json_file_cache at 0x7f03b4f920d0>
2022-02-27 06:06:41,869 - MainThread - botocore.loaders - DEBUG - Loading JSON file: /usr/local/aws-cli/v2/2.2.16/dist/botocore/data/sts/2011-06-15/service-2.json
2022-02-27 06:06:41,871 - MainThread - botocore.hooks - DEBUG - Event building-command-table.sts: calling handler <function add_waiters at 0x7f03b4de1430>
2022-02-27 06:06:41,890 - MainThread - awscli.clidriver - DEBUG - OrderedDict()
2022-02-27 06:06:41,890 - MainThread - botocore.hooks - DEBUG - Event building-argument-table.sts.get-caller-identity: calling handler <function add_streaming_output_arg at 0x7f03b4ddb3a0>
2022-02-27 06:06:41,890 - MainThread - botocore.hooks - DEBUG - Event building-argument-table.sts.get-caller-identity: calling handler <function add_cli_input_json at 0x7f03b57de280>
2022-02-27 06:06:41,891 - MainThread - botocore.hooks - DEBUG - Event building-argument-table.sts.get-caller-identity: calling handler <function add_cli_input_yaml at 0x7f03b57de550>
2022-02-27 06:06:41,891 - MainThread - botocore.hooks - DEBUG - Event building-argument-table.sts.get-caller-identity: calling handler <function unify_paging_params at 0x7f03b4f738b0>
2022-02-27 06:06:41,909 - MainThread - botocore.loaders - DEBUG - Loading JSON file: /usr/local/aws-cli/v2/2.2.16/dist/botocore/data/sts/2011-06-15/paginators-1.json
2022-02-27 06:06:41,910 - MainThread - botocore.hooks - DEBUG - Event building-argument-table.sts.get-caller-identity: calling handler <function add_generate_skeleton at 0x7f03b4e868b0>
2022-02-27 06:06:41,910 - MainThread - botocore.hooks - DEBUG - Event before-building-argument-table-parser.sts.get-caller-identity: calling handler <bound method OverrideRequiredArgsArgument.override_required_args of <awscli.customizations.cliinput.CliInputJSONArgument object at 0x7f03b44bbca0>>
2022-02-27 06:06:41,910 - MainThread - botocore.hooks - DEBUG - Event before-building-argument-table-parser.sts.get-caller-identity: calling handler <bound method OverrideRequiredArgsArgument.override_required_args of <awscli.customizations.cliinput.CliInputYAMLArgument object at 0x7f03b44bbc40>>
2022-02-27 06:06:41,911 - MainThread - botocore.hooks - DEBUG - Event before-building-argument-table-parser.sts.get-caller-identity: calling handler <bound method GenerateCliSkeletonArgument.override_required_args of <awscli.customizations.generatecliskeleton.GenerateCliSkeletonArgument object at 0x7f03b44bbc10>>
2022-02-27 06:06:41,912 - MainThread - botocore.hooks - DEBUG - Event load-cli-arg.sts.get-caller-identity.cli-input-json: calling handler <awscli.paramfile.URIArgumentHandler object at 0x7f03b44bb250>
2022-02-27 06:06:41,912 - MainThread - botocore.hooks - DEBUG - Event load-cli-arg.sts.get-caller-identity.cli-input-yaml: calling handler <awscli.paramfile.URIArgumentHandler object at 0x7f03b44bb250>
2022-02-27 06:06:41,912 - MainThread - botocore.hooks - DEBUG - Event load-cli-arg.sts.get-caller-identity.generate-cli-skeleton: calling handler <awscli.paramfile.URIArgumentHandler object at 0x7f03b44bb250>
2022-02-27 06:06:41,912 - MainThread - botocore.hooks - DEBUG - Event calling-command.sts.get-caller-identity: calling handler <bound method CliInputArgument.add_to_call_parameters of <awscli.customizations.cliinput.CliInputJSONArgument object at 0x7f03b44bbca0>>
2022-02-27 06:06:41,912 - MainThread - botocore.hooks - DEBUG - Event calling-command.sts.get-caller-identity: calling handler <bound method CliInputArgument.add_to_call_parameters of <awscli.customizations.cliinput.CliInputYAMLArgument object at 0x7f03b44bbc40>>
2022-02-27 06:06:41,913 - MainThread - botocore.hooks - DEBUG - Event calling-command.sts.get-caller-identity: calling handler <bound method GenerateCliSkeletonArgument.generate_skeleton of <awscli.customizations.generatecliskeleton.GenerateCliSkeletonArgument object at 0x7f03b44bbc10>>
2022-02-27 06:06:41,913 - MainThread - botocore.credentials - DEBUG - Looking for credentials via: env
2022-02-27 06:06:41,913 - MainThread - botocore.credentials - DEBUG - Looking for credentials via: assume-role
2022-02-27 06:06:41,913 - MainThread - botocore.credentials - DEBUG - Looking for credentials via: assume-role-with-web-identity
2022-02-27 06:06:41,914 - MainThread - botocore.credentials - DEBUG - Looking for credentials via: sso
2022-02-27 06:06:41,914 - MainThread - botocore.credentials - DEBUG - Looking for credentials via: shared-credentials-file
2022-02-27 06:06:41,914 - MainThread - botocore.credentials - DEBUG - Looking for credentials via: custom-process
2022-02-27 06:06:41,915 - MainThread - botocore.credentials - DEBUG - Looking for credentials via: config-file
2022-02-27 06:06:41,915 - MainThread - botocore.credentials - INFO - Credentials found in config file: ~/.aws/config
2022-02-27 06:06:41,916 - MainThread - botocore.loaders - DEBUG - Loading JSON file: /usr/local/aws-cli/v2/2.2.16/dist/botocore/data/endpoints.json
2022-02-27 06:06:41,926 - MainThread - botocore.hooks - DEBUG - Event choose-service-name: calling handler <function handle_service_name_alias at 0x7f03b714d550>
2022-02-27 06:06:41,927 - MainThread - botocore.hooks - DEBUG - Event creating-client-class.sts: calling handler <function add_generate_presigned_url at 0x7f03b7179790>
2022-02-27 06:06:41,930 - MainThread - botocore.endpoint - DEBUG - Setting sts timeout as (60, 60)
2022-02-27 06:06:41,931 - MainThread - botocore.hooks - DEBUG - Event provide-client-params.sts.GetCallerIdentity: calling handler <function base64_decode_input_blobs at 0x7f03b4d46430>
2022-02-27 06:06:41,931 - MainThread - botocore.hooks - DEBUG - Event before-parameter-build.sts.GetCallerIdentity: calling handler <function generate_idempotent_uuid at 0x7f03b716f5e0>
2022-02-27 06:06:41,932 - MainThread - botocore.hooks - DEBUG - Event before-call.sts.GetCallerIdentity: calling handler <function inject_api_version_header_if_needed at 0x7f03b70f5e50>
2022-02-27 06:06:41,932 - MainThread - botocore.endpoint - DEBUG - Making request for OperationModel(name=GetCallerIdentity) with params: {'url_path': '/', 'query_string': '', 'method': 'POST', 'headers': {'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8', 'User-Agent': 'aws-cli/2.2.16 Python/3.8.8 Linux/5.4.0-99-generic exe/x86_64.ubuntu.20 prompt/off command/sts.get-caller-identity'}, 'body': {'Action': 'GetCallerIdentity', 'Version': '2011-06-15'}, 'url': 'https://sts.ap-northeast-1.amazonaws.com/', 'context': {'client_region': 'ap-northeast-1', 'client_config': <botocore.config.Config object at 0x7f03b44a7040>, 'has_streaming_input': False, 'auth_type': None}}
2022-02-27 06:06:41,932 - MainThread - botocore.hooks - DEBUG - Event request-created.sts.GetCallerIdentity: calling handler <bound method RequestSigner.handler of <botocore.signers.RequestSigner object at 0x7f03b44a7130>>
2022-02-27 06:06:41,932 - MainThread - botocore.hooks - DEBUG - Event choose-signer.sts.GetCallerIdentity: calling handler <function set_operation_specific_signer at 0x7f03b716f4c0>
2022-02-27 06:06:41,933 - MainThread - botocore.auth - DEBUG - Calculating signature using v4 auth.
2022-02-27 06:06:41,933 - MainThread - botocore.auth - DEBUG - CanonicalRequest:
POST
/

content-type:application/x-www-form-urlencoded; charset=utf-8
host:sts.ap-northeast-1.amazonaws.com
x-amz-date:20220227T060641Z

content-type;host;x-amz-date
ab821ae955788b0e33ebd34c208442ccfc2d406e2edc5e7a39bd6458fbb4f843
2022-02-27 06:06:41,934 - MainThread - botocore.auth - DEBUG - StringToSign:
AWS4-HMAC-SHA256
20220227T060641Z
20220227/ap-northeast-1/sts/aws4_request
8ffcf91d31eb620e04726b8b3dd4077e760d0bc899319c0571b43d71961279b0
2022-02-27 06:06:41,934 - MainThread - botocore.auth - DEBUG - Signature:
7a499b994a8193777db67cf97e112f739242b1175d9b998a4c3f8c0778782a2d
2022-02-27 06:06:41,935 - MainThread - botocore.endpoint - DEBUG - Sending http request: <AWSPreparedRequest stream_output=False, method=POST, url=https://sts.ap-northeast-1.amazonaws.com/, headers={'Content-Type': b'application/x-www-form-urlencoded; charset=utf-8', 'User-Agent': b'aws-cli/2.2.16 Python/3.8.8 Linux/5.4.0-99-generic exe/x86_64.ubuntu.20 prompt/off command/sts.get-caller-identity', 'X-Amz-Date': b'20220227T060641Z', 'Authorization': b'AWS4-HMAC-SHA256 Credential=AKIA3TM7R3RLLGIJ4M4O/20220227/ap-northeast-1/sts/aws4_request, SignedHeaders=content-type;host;x-amz-date, Signature=7a499b994a8193777db67cf97e112f739242b1175d9b998a4c3f8c0778782a2d', 'Content-Length': '43'}>
2022-02-27 06:06:41,935 - MainThread - botocore.httpsession - DEBUG - Certificate path: /usr/local/aws-cli/v2/2.2.16/dist/botocore/cacert.pem
2022-02-27 06:06:41,936 - MainThread - urllib3.connectionpool - DEBUG - Starting new HTTPS connection (1): sts.ap-northeast-1.amazonaws.com:443
2022-02-27 06:06:42,140 - MainThread - urllib3.connectionpool - DEBUG - https://sts.ap-northeast-1.amazonaws.com:443 "POST / HTTP/1.1" 200 419
2022-02-27 06:06:42,140 - MainThread - botocore.parsers - DEBUG - Response headers: {'x-amzn-RequestId': 'df117602-4331-44f1-a1b6-44dc3b4fcb79', 'Content-Type': 'text/xml', 'Content-Length': '419', 'Date': 'Sun, 27 Feb 2022 06:06:41 GMT'}
2022-02-27 06:06:42,140 - MainThread - botocore.parsers - DEBUG - Response body:
b'<GetCallerIdentityResponse xmlns="https://sts.amazonaws.com/doc/2011-06-15/">\n  <GetCallerIdentityResult>\n    <Arn>arn:aws:iam::797587922006:user/khyup0629@hongikit.com</Arn>\n    <UserId>AIDA3TM7R3RLBCMLQ2A7J</UserId>\n    <Account>797587922006</Account>\n  </GetCallerIdentityResult>\n  <ResponseMetadata>\n    <RequestId>df117602-4331-44f1-a1b6-44dc3b4fcb79</RequestId>\n  </ResponseMetadata>\n</GetCallerIdentityResponse>\n'
2022-02-27 06:06:42,141 - MainThread - botocore.hooks - DEBUG - Event needs-retry.sts.GetCallerIdentity: calling handler <bound method RetryHandler.needs_retry of <botocore.retries.standard.RetryHandler object at 0x7f03b44a7b80>>
2022-02-27 06:06:42,141 - MainThread - botocore.retries.standard - DEBUG - Not retrying request.
2022-02-27 06:06:42,142 - MainThread - botocore.hooks - DEBUG - Event after-call.sts.GetCallerIdentity: calling handler <bound method RetryQuotaChecker.release_retry_quota of <botocore.retries.standard.RetryQuotaChecker object at 0x7f03b44a77c0>>
2022-02-27 06:06:42,142 - MainThread - awscli.formatter - DEBUG - RequestId: df117602-4331-44f1-a1b6-44dc3b4fcb79
{
    "UserId": "AIDA3TM7R3RLBCMLQ2A7J",
    "Account": "797587922006",
    "Arn": "arn:aws:iam::797587922006:user/khyup0629@hongikit.com"
}
```

