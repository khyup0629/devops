# AWS 메타데이터 상세

=> [AWS 메타데이터 상세 앤서블 공식 문서](https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_metadata_facts_module.html)

ec2-instance에는 메타데이터 API가 제공됩니다.

해당 API를 통해서 ec2-instance의 정보를 가져올 수 있습니다.

모듈은 `amazon.aws.ec2_metadata_facts`를 이용합니다.

## 애드혹 명령어

```
ansible <그룹명> -i <인벤토리명> -m amazon.aws.ec2_metadata_facts
```

```
ubuntu1 | SUCCESS => {
    "ansible_facts": {
        "ansible_ec2_ami_id": "ami-07cc75e9e8f9300eb",
        "ansible_ec2_ami_launch_index": "0",
        "ansible_ec2_ami_manifest_path": "(unknown)",
        "ansible_ec2_block_device_mapping_ami": "/dev/sda1",
        "ansible_ec2_block_device_mapping_ephemeral0": "sdb",
        "ansible_ec2_block_device_mapping_ephemeral1": "sdc",
        "ansible_ec2_block_device_mapping_root": "/dev/sda1",
        "ansible_ec2_events_maintenance_history": "[]",
        "ansible_ec2_events_maintenance_scheduled": "[]",
        "ansible_ec2_hibernation_configured": "false",
        "ansible_ec2_hostname": "ip-10-222-0-193.ap-northeast-2.compute.internal",
        "ansible_ec2_identity_credentials_ec2_info": "{\n  \"Code\" : \"Success\",\n  \"LastUpdated\" : \"2022-03-27T03:16:43Z\",\n  \"AccountId\" : \"707811555388\"\n}",
        "ansible_ec2_identity_credentials_ec2_info_accountid": "707811555388",
        "ansible_ec2_identity_credentials_ec2_info_code": "Success",
        "ansible_ec2_identity_credentials_ec2_info_lastupdated": "2022-03-27T03:16:43Z",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance": "{\n  \"Code\" : \"Success\",\n  \"LastUpdated\" : \"2022-03-27T03:15:53Z\",\n  \"Type\" : \"AWS-HMAC\",\n  \"AccessKeyId\" : \"ASIA2JTG3HA6PCFGCW7E\",\n  \"SecretAccessKey\" : \"PV4Zck5nC4ki8GdafYx8c0nqrz2PIeCGYV9FgFFJ\",\n  \"Token\" : \"IQoJb3JpZ2luX2VjEBMaDmFwLW5vcnRoZWFzdC0yIkcwRQIgW82cQSnpj4mxyp5hVaXSzFw+iQELvQiiMNiYyva+kJ4CIQC50N/Grq2w+A4gqwSgxBK9IgHO+ONfTy59hrFBHghVgyrjAwic//////////8BEAEaDDcwNzgxMTU1NTM4OCIMc62C8DGD4bLS0cSCKrcDt79LgGFZ31o2LrWHE1rKkAg1FQibbiqpgzUsg0HDvc5b/RiPfQMRsPdBVj6XYKjS4XUpvVYFoPfoDm4IzK7oXcBJGnxlAEQbsBPO4TWDtiD4cubcZWIlvCxAhv4QUdMfeY5Q5V0BQGtdkJayhrIyYz0S6L/Nr+BV8af/KPyiar3LPJwT8UB1d81cz+P08Z6L/6WQk+H83yWOwR0KY8lL8Xa3PthKzwESjz8p0PsqSSEnyB9lbp7FEEdYuz0khwVuxDcfxqQY0GvSGyngqpYfHS4NeP5kfRmhU3d5TdMKjDT023R5xrHMaJAbFklXxZfuGEuVkfV8YZswQ/lMoB3mxXZ9kuEDRVyodU62JV4Fao/0AIPk2q1dX050wrw8Awu0lAZkH9kdp5BfT1j1ZaqvVGaPTpjv+cvQmo2HbYeaMuVVIajEoNgMh7ojTStnYC7U+31DhaA0WcX4copWT6F82UAOEVmzSyXYMn/I2yG1YuOgBTIMDLC0DbbOheQRV0e88xwO57RK1wRxS6u9lhTlFd1KmxQaoGz5grZCSZaHzYctueBTkKUDc6g+q+mRydvE5pgcQAUidDCbrv+RBjqLAmup9jsSf9kmMsTCLxzL3mKUnfaj+IWfcOAu0R6qNck5RqzgN35oAWHi7bAAEBrExlcd7z1s3B39Sy0Yuxfze15tTIBJmhbTMZZkC1bynjAM4PGohXeUwwJUJTj6q7fRT6c/6EEK/nbw07YX8qV6xmNIyMVC+srNB6TyW5pli8PZVb2g2YFb/19VMqdw9n7KkxR+ODgeGequ93esK10PuCKSwI3zXyARIcULGm+0jbBeNkytcwDskXSAj6HKcEnkjZT1hku5GmMPZDKehFpGLHBHnMq0PzEiYtcz9vItiQgx5NiEbguIp3Wx8CGkdL+FZI1oPur6agnU3nt5XHBz79LXDUfXzD69F6+JYw==\",\n  \"Expiration\" : \"2022-03-27T09:41:58Z\"\n}",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_accesskeyid": "ASIA2JTG3HA6PCFGCW7E",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_code": "Success",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_expiration": "2022-03-27T09:41:58Z",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_lastupdated": "2022-03-27T03:15:53Z",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_secretaccesskey": "PV4Zck5nC4ki8GdafYx8c0nqrz2PIeCGYV9FgFFJ",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_token": "IQoJb3JpZ2luX2VjEBMaDmFwLW5vcnRoZWFzdC0yIkcwRQIgW82cQSnpj4mxyp5hVaXSzFw+iQELvQiiMNiYyva+kJ4CIQC50N/Grq2w+A4gqwSgxBK9IgHO+ONfTy59hrFBHghVgyrjAwic//////////8BEAEaDDcwNzgxMTU1NTM4OCIMc62C8DGD4bLS0cSCKrcDt79LgGFZ31o2LrWHE1rKkAg1FQibbiqpgzUsg0HDvc5b/RiPfQMRsPdBVj6XYKjS4XUpvVYFoPfoDm4IzK7oXcBJGnxlAEQbsBPO4TWDtiD4cubcZWIlvCxAhv4QUdMfeY5Q5V0BQGtdkJayhrIyYz0S6L/Nr+BV8af/KPyiar3LPJwT8UB1d81cz+P08Z6L/6WQk+H83yWOwR0KY8lL8Xa3PthKzwESjz8p0PsqSSEnyB9lbp7FEEdYuz0khwVuxDcfxqQY0GvSGyngqpYfHS4NeP5kfRmhU3d5TdMKjDT023R5xrHMaJAbFklXxZfuGEuVkfV8YZswQ/lMoB3mxXZ9kuEDRVyodU62JV4Fao/0AIPk2q1dX050wrw8Awu0lAZkH9kdp5BfT1j1ZaqvVGaPTpjv+cvQmo2HbYeaMuVVIajEoNgMh7ojTStnYC7U+31DhaA0WcX4copWT6F82UAOEVmzSyXYMn/I2yG1YuOgBTIMDLC0DbbOheQRV0e88xwO57RK1wRxS6u9lhTlFd1KmxQaoGz5grZCSZaHzYctueBTkKUDc6g+q+mRydvE5pgcQAUidDCbrv+RBjqLAmup9jsSf9kmMsTCLxzL3mKUnfaj+IWfcOAu0R6qNck5RqzgN35oAWHi7bAAEBrExlcd7z1s3B39Sy0Yuxfze15tTIBJmhbTMZZkC1bynjAM4PGohXeUwwJUJTj6q7fRT6c/6EEK/nbw07YX8qV6xmNIyMVC+srNB6TyW5pli8PZVb2g2YFb/19VMqdw9n7KkxR+ODgeGequ93esK10PuCKSwI3zXyARIcULGm+0jbBeNkytcwDskXSAj6HKcEnkjZT1hku5GmMPZDKehFpGLHBHnMq0PzEiYtcz9vItiQgx5NiEbguIp3Wx8CGkdL+FZI1oPur6agnU3nt5XHBz79LXDUfXzD69F6+JYw==",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_type": "AWS-HMAC",
        "ansible_ec2_instance_action": "none",
        "ansible_ec2_instance_id": "i-0140f65cf5b9ba76a",
        "ansible_ec2_instance_identity_document": "{\n  \"accountId\" : \"707811555388\",\n  \"architecture\" : \"x86_64\",\n  \"availabilityZone\" : \"ap-northeast-2a\",\n  \"billingProducts\" : null,\n  \"devpayProductCodes\" : null,\n  \"marketplaceProductCodes\" : null,\n  \"imageId\" : \"ami-07cc75e9e8f9300eb\",\n  \"instanceId\" : \"i-0140f65cf5b9ba76a\",\n  \"instanceType\" : \"t2.micro\",\n  \"kernelId\" : null,\n  \"pendingTime\" : \"2022-03-27T02:35:30Z\",\n  \"privateIp\" : \"10.222.0.193\",\n  \"ramdiskId\" : null,\n  \"region\" : \"ap-northeast-2\",\n  \"version\" : \"2017-09-30\"\n}",
        "ansible_ec2_instance_identity_document_accountid": "707811555388",
        "ansible_ec2_instance_identity_document_architecture": "x86_64",
        "ansible_ec2_instance_identity_document_availabilityzone": "ap-northeast-2a",
        "ansible_ec2_instance_identity_document_billingproducts": null,
        "ansible_ec2_instance_identity_document_devpayproductcodes": null,
        "ansible_ec2_instance_identity_document_imageid": "ami-07cc75e9e8f9300eb",
        "ansible_ec2_instance_identity_document_instanceid": "i-0140f65cf5b9ba76a",
        "ansible_ec2_instance_identity_document_instancetype": "t2.micro",
        "ansible_ec2_instance_identity_document_kernelid": null,
        "ansible_ec2_instance_identity_document_marketplaceproductcodes": null,
        "ansible_ec2_instance_identity_document_pendingtime": "2022-03-27T02:35:30Z",
        "ansible_ec2_instance_identity_document_privateip": "10.222.0.193",
        "ansible_ec2_instance_identity_document_ramdiskid": null,
        "ansible_ec2_instance_identity_document_region": "ap-northeast-2",
        "ansible_ec2_instance_identity_document_version": "2017-09-30",
        "ansible_ec2_instance_identity_pkcs7": "MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAaCAJIAEggHmewog\nICJhY2NvdW50SWQiIDogIjcwNzgxMTU1NTM4OCIsCiAgImFyY2hpdGVjdHVyZSIgOiAieDg2XzY0\nIiwKICAiYXZhaWxhYmlsaXR5Wm9uZSIgOiAiYXAtbm9ydGhlYXN0LTJhIiwKICAiYmlsbGluZ1By\nb2R1Y3RzIiA6IG51bGwsCiAgImRldnBheVByb2R1Y3RDb2RlcyIgOiBudWxsLAogICJtYXJrZXRw\nbGFjZVByb2R1Y3RDb2RlcyIgOiBudWxsLAogICJpbWFnZUlkIiA6ICJhbWktMDdjYzc1ZTllOGY5\nMzAwZWIiLAogICJpbnN0YW5jZUlkIiA6ICJpLTAxNDBmNjVjZjViOWJhNzZhIiwKICAiaW5zdGFu\nY2VUeXBlIiA6ICJ0Mi5taWNybyIsCiAgImtlcm5lbElkIiA6IG51bGwsCiAgInBlbmRpbmdUaW1l\nIiA6ICIyMDIyLTAzLTI3VDAyOjM1OjMwWiIsCiAgInByaXZhdGVJcCIgOiAiMTAuMjIyLjAuMTkz\nIiwKICAicmFtZGlza0lkIiA6IG51bGwsCiAgInJlZ2lvbiIgOiAiYXAtbm9ydGhlYXN0LTIiLAog\nICJ2ZXJzaW9uIiA6ICIyMDE3LTA5LTMwIgp9AAAAAAAAMYIBPzCCATsCAQEwaTBcMQswCQYDVQQG\nEwJVUzEZMBcGA1UECBMQV2FzaGluZ3RvbiBTdGF0ZTEQMA4GA1UEBxMHU2VhdHRsZTEgMB4GA1UE\nChMXQW1hem9uIFdlYiBTZXJ2aWNlcyBMTEMCCQCWukjZ5V4aZzAJBgUrDgMCGgUAoIGEMBgGCSqG\nSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMyNzAyMzUzM1owIwYJKoZI\nhvcNAQkEMRYEFHV5bHGeNux9yF9X/s7q27oDEV2fMCUGCSqGSIb3DQEJNDEYMBYwCQYFKw4DAhoF\nAKEJBgcqhkjOOAQDMAkGByqGSM44BAMELjAsAhQz24Nkz8m7nDpbejQ5ZiaICjyOCwIUYlFJUVyq\njn7axqq6mp4ArfQtnaoAAAAAAAA=",
        "ansible_ec2_instance_identity_rsa2048": "MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwGggCSABIIB\n5nsKICAiYWNjb3VudElkIiA6ICI3MDc4MTE1NTUzODgiLAogICJhcmNoaXRlY3R1cmUiIDogIng4\nNl82NCIsCiAgImF2YWlsYWJpbGl0eVpvbmUiIDogImFwLW5vcnRoZWFzdC0yYSIsCiAgImJpbGxp\nbmdQcm9kdWN0cyIgOiBudWxsLAogICJkZXZwYXlQcm9kdWN0Q29kZXMiIDogbnVsbCwKICAibWFy\na2V0cGxhY2VQcm9kdWN0Q29kZXMiIDogbnVsbCwKICAiaW1hZ2VJZCIgOiAiYW1pLTA3Y2M3NWU5\nZThmOTMwMGViIiwKICAiaW5zdGFuY2VJZCIgOiAiaS0wMTQwZjY1Y2Y1YjliYTc2YSIsCiAgImlu\nc3RhbmNlVHlwZSIgOiAidDIubWljcm8iLAogICJrZXJuZWxJZCIgOiBudWxsLAogICJwZW5kaW5n\nVGltZSIgOiAiMjAyMi0wMy0yN1QwMjozNTozMFoiLAogICJwcml2YXRlSXAiIDogIjEwLjIyMi4w\nLjE5MyIsCiAgInJhbWRpc2tJZCIgOiBudWxsLAogICJyZWdpb24iIDogImFwLW5vcnRoZWFzdC0y\nIiwKICAidmVyc2lvbiIgOiAiMjAxNy0wOS0zMCIKfQAAAAAAADGCAi8wggIrAgEBMGkwXDELMAkG\nA1UEBhMCVVMxGTAXBgNVBAgTEFdhc2hpbmd0b24gU3RhdGUxEDAOBgNVBAcTB1NlYXR0bGUxIDAe\nBgNVBAoTF0FtYXpvbiBXZWIgU2VydmljZXMgTExDAgkA24KAJwe04mEwDQYJYIZIAWUDBAIBBQCg\ngZgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIwMzI3MDIzNTMz\nWjAtBgkqhkiG9w0BCTQxIDAeMA0GCWCGSAFlAwQCAQUAoQ0GCSqGSIb3DQEBCwUAMC8GCSqGSIb3\nDQEJBDEiBCDNRSLy0pi7AGM5bmH/cVmhLpwmYcbXi0HnXccHy/kuPjANBgkqhkiG9w0BAQsFAASC\nAQBtjwVUuGrCVpLmvKA3cXSmIACST6D4OsXf9H8ZPoqPd0FSgVq7/RaB6SXinfRvjL8uXvIyjJjX\nBU/c+7J+x5OnZWG+dapOh7SBs7VqRVv9kgm2ixnX4yunTlGzvloWrUkdLiVEe/+ED/INuA5yjVUZ\nMursx3H3KKe+ACbKgn3iqAteAXW8Lmnh6/mH6Fqi/2e5X469SxCgH6jPct93OKMCfZLOJdXCF2cz\ncEwuqWKqzx0aViumOa/todfwqKNESTkQEa7L30wVvqidiQcPEUKnDI4T20MzdRhJeinbwzPOBAOJ\nxm8LrEJXXEezjDYVxlD3qoNmhAx58UK2m7znqDArAAAAAAAA",
        "ansible_ec2_instance_identity_signature": "IuwMK/ZUWz/BJc4Zi4HGMKI2b/ech5b5YCFnr5X+VXKuW8jCR8A9Kly1jaPSBIFqCsLOfBnDnxCV\nzBDYdV1znWYaDldWFmnY3tbs1FsUUnjlNKIKawql6VvkPMy/1qERk7BCt5tn+Vd/WGWn4++fRZkX\nTiomOq2SWN/N9uLYklM=",
        "ansible_ec2_instance_life_cycle": "on-demand",
        "ansible_ec2_instance_type": "t2.micro",
        "ansible_ec2_local_hostname": "ip-10-222-0-193.ap-northeast-2.compute.internal",
        "ansible_ec2_local_ipv4": "10.222.0.193",
        "ansible_ec2_mac": "02:19:61:74:70:7c",
        "ansible_ec2_metrics_vhostmd": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_device_number": "0",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_interface_id": "eni-0301d1bc2bfba1484",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_ipv4_associations_13.125.132.243": "10.222.0.193",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_local_hostname": "ip-10-222-0-193.ap-northeast-2.compute.internal",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_local_ipv4s": "10.222.0.193",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_mac": "02:19:61:74:70:7c",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_owner_id": "707811555388",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_public_hostname": "ec2-13-125-132-243.ap-northeast-2.compute.amazonaws.com",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_public_ipv4s": "13.125.132.243",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_security_group_ids": "sg-0819246554e56da6e",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_security_groups": "hyeob-study-ssh",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_subnet_id": "subnet-03cfa2b3a431d3924",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_subnet_ipv4_cidr_block": "10.222.0.0/24",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_vpc_id": "vpc-03b77540adee25cd0",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_vpc_ipv4_cidr_block": "10.222.0.0/16",
        "ansible_ec2_network_interfaces_macs_02_19_61_74_70_7c_vpc_ipv4_cidr_blocks": "10.222.0.0/16",
        "ansible_ec2_placement_availability_zone": "ap-northeast-2a",
        "ansible_ec2_placement_availability_zone_id": "apne2-az1",
        "ansible_ec2_placement_region": "ap-northeast-2",
        "ansible_ec2_profile": "default-hvm",
        "ansible_ec2_public_hostname": "ec2-13-125-132-243.ap-northeast-2.compute.amazonaws.com",
        "ansible_ec2_public_ipv4": "13.125.132.243",
        "ansible_ec2_public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZ7gBYx3P3mV8IISUwfI7VVUftVG1EmcC0xpUs0eBU8o2P7o2qvggo+OrEBjtRne7i924wzVz8Y6ZcSt+ugdIwdfVjQ/uXivpidUKZOBUmXd6rHWJ57EKpAucQCEumjeNPZTtfkbYZT670i2yCglziP+x8rHLOl6ZWIbCWCNTvme6tLz0qKYtxSgrP2K+oxYRFHKRl5PO7uFpNuB6eYm2eKz49gQ6tUh2Mcp1tHWoFmkVUyt7pZKlf6i36jNItO14Of/8LZvMm39BWIlKTaTTItxPhRe98g/rIoILnCTy2FnFlaNLQGh/T7YlF5qzwIIkYciO+B4rcyPD9XQ44Ic/D hyeob-home-keypair\n",
        "ansible_ec2_reservation_id": "r-023be5c36c5581994",
        "ansible_ec2_security_groups": "hyeob-study-ssh",
        "ansible_ec2_services_domain": "amazonaws.com",
        "ansible_ec2_services_partition": "aws",
        "ansible_ec2_user_data": "None",
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false
}
ubuntu2 | SUCCESS => {
    "ansible_facts": {
        "ansible_ec2_ami_id": "ami-07cc75e9e8f9300eb",
        "ansible_ec2_ami_launch_index": "0",
        "ansible_ec2_ami_manifest_path": "(unknown)",
        "ansible_ec2_block_device_mapping_ami": "/dev/sda1",
        "ansible_ec2_block_device_mapping_ephemeral0": "sdb",
        "ansible_ec2_block_device_mapping_ephemeral1": "sdc",
        "ansible_ec2_block_device_mapping_root": "/dev/sda1",
        "ansible_ec2_events_maintenance_history": "[]",
        "ansible_ec2_events_maintenance_scheduled": "[]",
        "ansible_ec2_hibernation_configured": "false",
        "ansible_ec2_hostname": "ip-10-222-0-95.ap-northeast-2.compute.internal",
        "ansible_ec2_identity_credentials_ec2_info": "{\n  \"Code\" : \"Success\",\n  \"LastUpdated\" : \"2022-03-27T04:12:14Z\",\n  \"AccountId\" : \"707811555388\"\n}",
        "ansible_ec2_identity_credentials_ec2_info_accountid": "707811555388",
        "ansible_ec2_identity_credentials_ec2_info_code": "Success",
        "ansible_ec2_identity_credentials_ec2_info_lastupdated": "2022-03-27T04:12:14Z",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance": "{\n  \"Code\" : \"Success\",\n  \"LastUpdated\" : \"2022-03-27T04:12:04Z\",\n  \"Type\" : \"AWS-HMAC\",\n  \"AccessKeyId\" : \"ASIA2JTG3HA6PYAWILVN\",\n  \"SecretAccessKey\" : \"UoHCmwFb2mCq8sWOh9p5VYyY/V+IOC2svqpB/Rry\",\n  \"Token\" : \"IQoJb3JpZ2luX2VjEBQaDmFwLW5vcnRoZWFzdC0yIkcwRQIhAK+gn/xuwrmD6L1JuOVrUo/oMkpi3aLwnUdTMbr7mHbWAiAcYVzbykTRSYz4MH6Anl1Nm/rFSF6FqH3dy1GvtUiV0CrjAwid//////////8BEAEaDDcwNzgxMTU1NTM4OCIM50U8gyJ2FefTfMJIKrcDrIqZh64F2QWEne6Z2JLut5KoLMHB18T/WYwouQ2oTpCK8AgzvL+an6Jr9JCmooXiVv3kcAXeA6l6jr06/XehIhlocWTL82tyS1mNKEVZGWnTTAl/sMyZOZTZAq1yTI2qmw9bSop622NbKiybb9G1+pLoqwM+LV/PNtZrcM3eivuB1GQ4PK0DayCOi7jvIXZII6kTdZ5O+eyZqyx0TDw4EQMUYvqy8U+C30r/TktuD647Y3idv6GfM35OBxZpVQUL4GR5xKgjxB9v9Coil1vPM3i6wlF0naz922IHhNosPUfV7E6MBe0/QnJIIctrn9JCqFe4+VlS7rXB7HJNDhLuWOOPI7hs/tfy4CzncptUNI2Qy7uZxgrZrQpA4hz2kFrqDme90OH9xyoQZrTg70byEY0YbO3ATT3I39Tili+i5hKBWd4/99rwZ4msMARREznMrEv6IXY8WFi5FRrz0I2AqPznC76gz7txwINXmrJQSOLc2V8knSpwgF26ZjRYoWyIfctRn17Cof/RERb0lxXEYB2b9c8KC6RfjooLWsgFS2pL3luX1bifZFDgf36FH9yLwDFl99YtwDCAyP+RBjqLAiizywhXlIK0nQUyfcbgM+FhMH7m/BhtaFX7NST7ROwujT7PCU1VHW846X28t/saKykLylL+1d4BhUmune26XrWI+eg3LleFdOM1mdRU+Q0T1f6VEJG2T040w+YX0jsYdBP7e30Nr6Vq4PaAw6bm1gYdpWQ12C7qEM+JfnWUzU880gB0Bl5TOPzjVnvhz5nng21r8hGbANOReHZxx8uhhrHAzIyVtxxULaYywZ/MJcz6dMtjQFsaQtgMD54ARges6O6+NPLCZrZjkdpdX/d8eYMk5UYqpEPxgE4AwufBRhRAKcM2OfhRB4P+h2zRXRl60cg9AswnNUDmkqSE6euxiSJHtm4a2u2hoCUSHQ==\",\n  \"Expiration\" : \"2022-03-27T10:19:15Z\"\n}",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_accesskeyid": "ASIA2JTG3HA6PYAWILVN",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_code": "Success",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_expiration": "2022-03-27T10:19:15Z",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_lastupdated": "2022-03-27T04:12:04Z",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_secretaccesskey": "UoHCmwFb2mCq8sWOh9p5VYyY/V+IOC2svqpB/Rry",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_token": "IQoJb3JpZ2luX2VjEBQaDmFwLW5vcnRoZWFzdC0yIkcwRQIhAK+gn/xuwrmD6L1JuOVrUo/oMkpi3aLwnUdTMbr7mHbWAiAcYVzbykTRSYz4MH6Anl1Nm/rFSF6FqH3dy1GvtUiV0CrjAwid//////////8BEAEaDDcwNzgxMTU1NTM4OCIM50U8gyJ2FefTfMJIKrcDrIqZh64F2QWEne6Z2JLut5KoLMHB18T/WYwouQ2oTpCK8AgzvL+an6Jr9JCmooXiVv3kcAXeA6l6jr06/XehIhlocWTL82tyS1mNKEVZGWnTTAl/sMyZOZTZAq1yTI2qmw9bSop622NbKiybb9G1+pLoqwM+LV/PNtZrcM3eivuB1GQ4PK0DayCOi7jvIXZII6kTdZ5O+eyZqyx0TDw4EQMUYvqy8U+C30r/TktuD647Y3idv6GfM35OBxZpVQUL4GR5xKgjxB9v9Coil1vPM3i6wlF0naz922IHhNosPUfV7E6MBe0/QnJIIctrn9JCqFe4+VlS7rXB7HJNDhLuWOOPI7hs/tfy4CzncptUNI2Qy7uZxgrZrQpA4hz2kFrqDme90OH9xyoQZrTg70byEY0YbO3ATT3I39Tili+i5hKBWd4/99rwZ4msMARREznMrEv6IXY8WFi5FRrz0I2AqPznC76gz7txwINXmrJQSOLc2V8knSpwgF26ZjRYoWyIfctRn17Cof/RERb0lxXEYB2b9c8KC6RfjooLWsgFS2pL3luX1bifZFDgf36FH9yLwDFl99YtwDCAyP+RBjqLAiizywhXlIK0nQUyfcbgM+FhMH7m/BhtaFX7NST7ROwujT7PCU1VHW846X28t/saKykLylL+1d4BhUmune26XrWI+eg3LleFdOM1mdRU+Q0T1f6VEJG2T040w+YX0jsYdBP7e30Nr6Vq4PaAw6bm1gYdpWQ12C7qEM+JfnWUzU880gB0Bl5TOPzjVnvhz5nng21r8hGbANOReHZxx8uhhrHAzIyVtxxULaYywZ/MJcz6dMtjQFsaQtgMD54ARges6O6+NPLCZrZjkdpdX/d8eYMk5UYqpEPxgE4AwufBRhRAKcM2OfhRB4P+h2zRXRl60cg9AswnNUDmkqSE6euxiSJHtm4a2u2hoCUSHQ==",
        "ansible_ec2_identity_credentials_ec2_security_credentials_ec2_instance_type": "AWS-HMAC",
        "ansible_ec2_instance_action": "none",
        "ansible_ec2_instance_id": "i-00e3338c5c02cfd02",
        "ansible_ec2_instance_identity_document": "{\n  \"accountId\" : \"707811555388\",\n  \"architecture\" : \"x86_64\",\n  \"availabilityZone\" : \"ap-northeast-2a\",\n  \"billingProducts\" : null,\n  \"devpayProductCodes\" : null,\n  \"marketplaceProductCodes\" : null,\n  \"imageId\" : \"ami-07cc75e9e8f9300eb\",\n  \"instanceId\" : \"i-00e3338c5c02cfd02\",\n  \"instanceType\" : \"t2.micro\",\n  \"kernelId\" : null,\n  \"pendingTime\" : \"2022-03-27T02:35:30Z\",\n  \"privateIp\" : \"10.222.0.95\",\n  \"ramdiskId\" : null,\n  \"region\" : \"ap-northeast-2\",\n  \"version\" : \"2017-09-30\"\n}",
        "ansible_ec2_instance_identity_document_accountid": "707811555388",
        "ansible_ec2_instance_identity_document_architecture": "x86_64",
        "ansible_ec2_instance_identity_document_availabilityzone": "ap-northeast-2a",
        "ansible_ec2_instance_identity_document_billingproducts": null,
        "ansible_ec2_instance_identity_document_devpayproductcodes": null,
        "ansible_ec2_instance_identity_document_imageid": "ami-07cc75e9e8f9300eb",
        "ansible_ec2_instance_identity_document_instanceid": "i-00e3338c5c02cfd02",
        "ansible_ec2_instance_identity_document_instancetype": "t2.micro",
        "ansible_ec2_instance_identity_document_kernelid": null,
        "ansible_ec2_instance_identity_document_marketplaceproductcodes": null,
        "ansible_ec2_instance_identity_document_pendingtime": "2022-03-27T02:35:30Z",
        "ansible_ec2_instance_identity_document_privateip": "10.222.0.95",
        "ansible_ec2_instance_identity_document_ramdiskid": null,
        "ansible_ec2_instance_identity_document_region": "ap-northeast-2",
        "ansible_ec2_instance_identity_document_version": "2017-09-30",
        "ansible_ec2_instance_identity_pkcs7": "MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAaCAJIAEggHlewog\nICJhY2NvdW50SWQiIDogIjcwNzgxMTU1NTM4OCIsCiAgImFyY2hpdGVjdHVyZSIgOiAieDg2XzY0\nIiwKICAiYXZhaWxhYmlsaXR5Wm9uZSIgOiAiYXAtbm9ydGhlYXN0LTJhIiwKICAiYmlsbGluZ1By\nb2R1Y3RzIiA6IG51bGwsCiAgImRldnBheVByb2R1Y3RDb2RlcyIgOiBudWxsLAogICJtYXJrZXRw\nbGFjZVByb2R1Y3RDb2RlcyIgOiBudWxsLAogICJpbWFnZUlkIiA6ICJhbWktMDdjYzc1ZTllOGY5\nMzAwZWIiLAogICJpbnN0YW5jZUlkIiA6ICJpLTAwZTMzMzhjNWMwMmNmZDAyIiwKICAiaW5zdGFu\nY2VUeXBlIiA6ICJ0Mi5taWNybyIsCiAgImtlcm5lbElkIiA6IG51bGwsCiAgInBlbmRpbmdUaW1l\nIiA6ICIyMDIyLTAzLTI3VDAyOjM1OjMwWiIsCiAgInByaXZhdGVJcCIgOiAiMTAuMjIyLjAuOTUi\nLAogICJyYW1kaXNrSWQiIDogbnVsbCwKICAicmVnaW9uIiA6ICJhcC1ub3J0aGVhc3QtMiIsCiAg\nInZlcnNpb24iIDogIjIwMTctMDktMzAiCn0AAAAAAAAxggE/MIIBOwIBATBpMFwxCzAJBgNVBAYT\nAlVTMRkwFwYDVQQIExBXYXNoaW5ndG9uIFN0YXRlMRAwDgYDVQQHEwdTZWF0dGxlMSAwHgYDVQQK\nExdBbWF6b24gV2ViIFNlcnZpY2VzIExMQwIJAJa6SNnlXhpnMAkGBSsOAwIaBQCggYQwGAYJKoZI\nhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIwMzI3MDIzNTMzWjAjBgkqhkiG\n9w0BCQQxFgQUVc4CC96Wy7w5iCCRf8rf9D04hPcwJQYJKoZIhvcNAQk0MRgwFjAJBgUrDgMCGgUA\noQkGByqGSM44BAMwCQYHKoZIzjgEAwQuMCwCFFK0HmXQzcYOKn3VX/1GILKOeqcIAhRO6rOjakWh\neSPaJKDZKXRRA3mOogAAAAAAAA==",
        "ansible_ec2_instance_identity_rsa2048": "MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwGggCSABIIB\n5XsKICAiYWNjb3VudElkIiA6ICI3MDc4MTE1NTUzODgiLAogICJhcmNoaXRlY3R1cmUiIDogIng4\nNl82NCIsCiAgImF2YWlsYWJpbGl0eVpvbmUiIDogImFwLW5vcnRoZWFzdC0yYSIsCiAgImJpbGxp\nbmdQcm9kdWN0cyIgOiBudWxsLAogICJkZXZwYXlQcm9kdWN0Q29kZXMiIDogbnVsbCwKICAibWFy\na2V0cGxhY2VQcm9kdWN0Q29kZXMiIDogbnVsbCwKICAiaW1hZ2VJZCIgOiAiYW1pLTA3Y2M3NWU5\nZThmOTMwMGViIiwKICAiaW5zdGFuY2VJZCIgOiAiaS0wMGUzMzM4YzVjMDJjZmQwMiIsCiAgImlu\nc3RhbmNlVHlwZSIgOiAidDIubWljcm8iLAogICJrZXJuZWxJZCIgOiBudWxsLAogICJwZW5kaW5n\nVGltZSIgOiAiMjAyMi0wMy0yN1QwMjozNTozMFoiLAogICJwcml2YXRlSXAiIDogIjEwLjIyMi4w\nLjk1IiwKICAicmFtZGlza0lkIiA6IG51bGwsCiAgInJlZ2lvbiIgOiAiYXAtbm9ydGhlYXN0LTIi\nLAogICJ2ZXJzaW9uIiA6ICIyMDE3LTA5LTMwIgp9AAAAAAAAMYICLzCCAisCAQEwaTBcMQswCQYD\nVQQGEwJVUzEZMBcGA1UECBMQV2FzaGluZ3RvbiBTdGF0ZTEQMA4GA1UEBxMHU2VhdHRsZTEgMB4G\nA1UEChMXQW1hem9uIFdlYiBTZXJ2aWNlcyBMTEMCCQDbgoAnB7TiYTANBglghkgBZQMEAgEFAKCB\nmDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMjAzMjcwMjM1MzNa\nMC0GCSqGSIb3DQEJNDEgMB4wDQYJYIZIAWUDBAIBBQChDQYJKoZIhvcNAQELBQAwLwYJKoZIhvcN\nAQkEMSIEIJh2b6+aW/nznQMIwKfNYnc0kAOP4QfjoA172x2grPg7MA0GCSqGSIb3DQEBCwUABIIB\nABdJJx4EafESYy8TSmnNIPeSTFb0tM8IZYzHPuMCLTW19ZZqWERf/4eFeo52VqqNiudL54r/8mdQ\nH2YEHWoce7sJ4JCKMZHI27DyAuKQZ+FL2h8l4cRPvmcThCrmK/pbC7k7TKayFhjTksChADvhmhSo\nwuxXzQhUq0/xrCgPMNHTPmHOPtXARzXiMVpKl6XH7NCmlJs2+XRvFIW8XDTCaeJd+NsF+bvHnvGZ\nnIukiCw4m+vpYOOKqNU+bCiRR7Tm3Zeo0OEnqwNyIO7xhlFBf21VanCLdrHl8b8ueuLMCNJiTu+k\nS9S86iLvMFxoP72rmcPXsIMew/DFGzS2cjY3MvAAAAAAAAA=",
        "ansible_ec2_instance_identity_signature": "fHbefaoDSSUvgU4Oa0ENSUjpDT0L0VaHlK+i2cEQrHzIE2OFjcj+lrFLBYvMsXa/7++H86g38xst\nC/Obf2SDGUL7y7G3znx0BDiIViGsCduDpS51PW/y1jWKGn/HPBUOV81LqNJzjenJVVmmFYpX7pb2\nNyatzHIVtbSNjdcKIdg=",
        "ansible_ec2_instance_life_cycle": "on-demand",
        "ansible_ec2_instance_type": "t2.micro",
        "ansible_ec2_local_hostname": "ip-10-222-0-95.ap-northeast-2.compute.internal",
        "ansible_ec2_local_ipv4": "10.222.0.95",
        "ansible_ec2_mac": "02:44:59:b9:cd:0e",
        "ansible_ec2_metrics_vhostmd": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_device_number": "0",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_interface_id": "eni-08b0ccc16e6d7cafb",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_ipv4_associations_13.124.244.199": "10.222.0.95",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_local_hostname": "ip-10-222-0-95.ap-northeast-2.compute.internal",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_local_ipv4s": "10.222.0.95",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_mac": "02:44:59:b9:cd:0e",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_owner_id": "707811555388",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_public_hostname": "ec2-13-124-244-199.ap-northeast-2.compute.amazonaws.com",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_public_ipv4s": "13.124.244.199",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_security_group_ids": "sg-0819246554e56da6e",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_security_groups": "hyeob-study-ssh",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_subnet_id": "subnet-03cfa2b3a431d3924",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_subnet_ipv4_cidr_block": "10.222.0.0/24",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_vpc_id": "vpc-03b77540adee25cd0",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_vpc_ipv4_cidr_block": "10.222.0.0/16",
        "ansible_ec2_network_interfaces_macs_02_44_59_b9_cd_0e_vpc_ipv4_cidr_blocks": "10.222.0.0/16",
        "ansible_ec2_placement_availability_zone": "ap-northeast-2a",
        "ansible_ec2_placement_availability_zone_id": "apne2-az1",
        "ansible_ec2_placement_region": "ap-northeast-2",
        "ansible_ec2_profile": "default-hvm",
        "ansible_ec2_public_hostname": "ec2-13-124-244-199.ap-northeast-2.compute.amazonaws.com",
        "ansible_ec2_public_ipv4": "13.124.244.199",
        "ansible_ec2_public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZ7gBYx3P3mV8IISUwfI7VVUftVG1EmcC0xpUs0eBU8o2P7o2qvggo+OrEBjtRne7i924wzVz8Y6ZcSt+ugdIwdfVjQ/uXivpidUKZOBUmXd6rHWJ57EKpAucQCEumjeNPZTtfkbYZT670i2yCglziP+x8rHLOl6ZWIbCWCNTvme6tLz0qKYtxSgrP2K+oxYRFHKRl5PO7uFpNuB6eYm2eKz49gQ6tUh2Mcp1tHWoFmkVUyt7pZKlf6i36jNItO14Of/8LZvMm39BWIlKTaTTItxPhRe98g/rIoILnCTy2FnFlaNLQGh/T7YlF5qzwIIkYciO+B4rcyPD9XQ44Ic/D hyeob-home-keypair\n",
        "ansible_ec2_reservation_id": "r-0ca52e6b4c8a66a4c",
        "ansible_ec2_security_groups": "hyeob-study-ssh",
        "ansible_ec2_services_domain": "amazonaws.com",
        "ansible_ec2_services_partition": "aws",
        "ansible_ec2_user_data": "None",
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false
}
```

## 플레이북 코드

`amazon.aws.ec2_metadata_facts` 모듈을 이용하면 상세들이 있는데 참조하기가 번거로운 상세들이 존재합니다.

이런 것들은 `set_fact` 모듈을 이용해 `key` 값을 간단하게 변경해 새롭게 상세에 추가해줄 수 있습니다.

아래 플레이북을 실행하기 전에 반드시 `pip install netaddr`을 실행합니다.

``` yaml
---

- name: Gather EC2 Metadata Facts
  hosts: ubuntu
  become: true
  tasks:
  # Docs: https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_metadata_facts_module.html
  - name: "Gather EC2 Metadata Facts"
    amazon.aws.ec2_metadata_facts: {}

  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
  - name: "Debug Ansible facts"
    debug:
      var: ansible_facts

  - name: "Set VPC CIDR"
    set_fact:
      vpc_cidr: "{{ (ansible_facts | dict2items | selectattr('key', 'match', '^ec2_network_interfaces_macs_.*_vpc_ipv4_cidr_block$') | map(attribute='value'))[0] }}"

  - name: "Debug VPC CIDR"
    debug:
      var: vpc_cidr

  - name: "Set VPC facts"
    set_fact:
      vpc_dns_server: '{{ vpc_cidr | ipaddr(2) | ipaddr("address") }}'
      vpc_network: '{{ vpc_cidr | ipaddr("network") }}'
      vpc_netmask: '{{ vpc_cidr | ipaddr("netmask") }}'

  - name: "Debug variables"
    debug:
      var: vars
```

`"{{ (ansible_facts | dict2items | selectattr('key', 'match', '^ec2_network_interfaces_macs_.*_vpc_ipv4_cidr_block$') | map(attribute='value'))[0] }}"`   
- `ansible_facts`를 딕셔너리에서 리스트 형태(`[ {key1:<키>, value1:<벨류>}, {key2:<키>, value2:<벨류>}, ... ]`)로 바꿉니다
- `selectattr`은 속성값을 선택하는 것으로, `key` `정규표현식`과 `match`되는 속성을 골라냅니다.   
![image](https://user-images.githubusercontent.com/43658658/160266830-49dbb7ae-5bca-4eaf-aa85-fc7fbec9945d.png)

- `map(attribute='value')`을 통해 골라낸 속성의 value 값을 리스트 형태(`[<벨류1>, <벨류2>, ... ]`)로 가지고, 인덱스 0번을 조회합니다.

