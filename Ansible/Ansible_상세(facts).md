# 앤서블 상세(facts)

=> [앤서블 상세에 대한 공식 문서 설명](https://docs.ansible.com/ansible/latest/user_guide/playbooks_vars_facts.html#ansible-facts)

`gather_facts: false` : 상세를 모으지 않도록 하는 설정. 대규모 시스템 관리 시 성능 향상. 테스트 환경에서 빠른 실행.   
- 각 플레이에는 위 옵션을 주고, `debug` 모듈을 통해 `ansible_facts`를 출력해서 상세를 확인하는 트릭이 있습니다.

### 코드

``` yaml
---

- name: Prepare Amazon Linux
  hosts: amazon
  become: true
  gather_facts: false
  tasks:
  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
  - name: "Install python on Amazon Linux"
    yum:
      name: "python3"
      state: "present"

- name: Prepare Ubuntu
  hosts: ubuntu
  become: true
  gather_facts: false
  tasks:
  - name: "Install python on Ubuntu"
    apt:
      name: "python3"
      state: "present"
      update_cache: true

- name: Debug
  hosts: all
  become: true
  tasks:
  # Docs: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
  - name: "Debug Ansible facts"
    debug:
      var: ansible_facts
```

### 결과값

```
PLAY [Prepare Amazon Linux] **********************************************************

TASK [Install python on Amazon Linux] ************************************************
[WARNING]: Platform linux on host amazon2 is using the discovered Python interpreter
at /usr/bin/python3.7, but future installation of another Python interpreter could
change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.12/reference_appendices/interpreter_discovery.html for more information.
ok: [amazon2]
[WARNING]: Platform linux on host amazon1 is using the discovered Python interpreter
at /usr/bin/python3.7, but future installation of another Python interpreter could
change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.12/reference_appendices/interpreter_discovery.html for more information.
ok: [amazon1]

PLAY [Prepare Ubuntu] ****************************************************************

TASK [Install python on Ubuntu] ******************************************************
ok: [ubuntu1]
ok: [ubuntu2]

PLAY [Debug] *************************************************************************

TASK [Gathering Facts] ***************************************************************
ok: [amazon1]
ok: [amazon2]
ok: [ubuntu2]
ok: [ubuntu1]

TASK [Debug Ansible facts] ***********************************************************
ok: [amazon1] => {
    "ansible_facts": {
        "all_ipv4_addresses": [
            "10.222.0.15"
        ],
        "all_ipv6_addresses": [
            "fe80::71:7bff:fe2d:ccb8"
        ],
        "ansible_local": {},
        "apparmor": {
            "status": "disabled"
        },
        "architecture": "x86_64",
        "bios_date": "08/24/2006",
        "bios_vendor": "Xen",
        "bios_version": "4.11.amazon",
        "board_asset_tag": "NA",
        "board_name": "NA",
        "board_serial": "NA",
        "board_vendor": "NA",
        "board_version": "NA",
        "chassis_asset_tag": "NA",
        "chassis_serial": "NA",
        "chassis_vendor": "Xen",
        "chassis_version": "NA",
        "cmdline": {
            "BOOT_IMAGE": "/boot/vmlinuz-4.14.268-205.500.amzn2.x86_64",
            "biosdevname": "0",
            "console": "ttyS0,115200n8",
            "net.ifnames": "0",
            "nvme_core.io_timeout": "4294967295",
            "rd.emergency": "poweroff",
            "rd.shell": "0",
            "ro": true,
            "root": "UUID=dc74d1d7-c6e7-4592-931f-70681a786a83"
        },
        "date_time": {
            "date": "2022-03-27",
            "day": "27",
            "epoch": "1648352759",
            "epoch_int": "1648352759",
            "hour": "03",
            "iso8601": "2022-03-27T03:45:59Z",
            "iso8601_basic": "20220327T034559107615",
            "iso8601_basic_short": "20220327T034559",
            "iso8601_micro": "2022-03-27T03:45:59.107615Z",
            "minute": "45",
            "month": "03",
            "second": "59",
            "time": "03:45:59",
            "tz": "UTC",
            "tz_dst": "UTC",
            "tz_offset": "+0000",
            "weekday": "Sunday",
            "weekday_number": "0",
            "weeknumber": "12",
            "year": "2022"
        },
        "default_ipv4": {
            "address": "10.222.0.15",
            "alias": "eth0",
            "broadcast": "10.222.0.255",
            "gateway": "10.222.0.1",
            "interface": "eth0",
            "macaddress": "02:71:7b:2d:cc:b8",
            "mtu": 9001,
            "netmask": "255.255.255.0",
            "network": "10.222.0.0",
            "type": "ether"
        },
        "default_ipv6": {},
        "device_links": {
            "ids": {},
            "labels": {
                "xvda1": [
                    "\\x2f"
                ]
            },
            "masters": {},
            "uuids": {
                "xvda1": [
                    "dc74d1d7-c6e7-4592-931f-70681a786a83"
                ]
            }
        },
        "devices": {
            "xvda": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {
                    "xvda1": {
                        "holders": [],
                        "links": {
                            "ids": [],
                            "labels": [
                                "\\x2f"
                            ],
                            "masters": [],
                            "uuids": [
                                "dc74d1d7-c6e7-4592-931f-70681a786a83"
                            ]
                        },
                        "sectors": "16773087",
                        "sectorsize": 512,
                        "size": "8.00 GB",
                        "start": "4096",
                        "uuid": "dc74d1d7-c6e7-4592-931f-70681a786a83"
                    }
                },
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "noop",
                "sectors": "16777216",
                "sectorsize": "512",
                "size": "8.00 GB",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            }
        },
        "discovered_interpreter_python": "/usr/bin/python3.7",
        "distribution": "Amazon",
        "distribution_file_parsed": true,
        "distribution_file_path": "/etc/os-release",
        "distribution_file_variety": "Amazon",
        "distribution_major_version": "2",
        "distribution_minor_version": "NA",
        "distribution_release": "NA",
        "distribution_version": "2",
        "dns": {
            "nameservers": [
                "10.222.0.2"
            ],
            "options": {
                "attempts": "5",
                "timeout": "2"
            },
            "search": [
                "ap-northeast-2.compute.internal"
            ]
        },
        "domain": "ap-northeast-2.compute.internal",
        "effective_group_id": 0,
        "effective_user_id": 0,
        "env": {
            "HOME": "/root",
            "LANG": "en_US.UTF-8",
            "LOGNAME": "root",
            "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:",
            "MAIL": "/var/mail/ec2-user",
            "PATH": "/sbin:/bin:/usr/sbin:/usr/bin",
            "PWD": "/home/ec2-user",
            "SHELL": "/bin/bash",
            "SHLVL": "1",
            "SUDO_COMMAND": "/bin/sh -c echo BECOME-SUCCESS-lypdfkyoipinuzpsofofnvamkhhrlnrx ; /usr/bin/python3.7 /home/ec2-user/.ansible/tmp/ansible-tmp-1648352758.6290746-1826207-183143173381397/AnsiballZ_setup.py",
            "SUDO_GID": "1000",
            "SUDO_UID": "1000",
            "SUDO_USER": "ec2-user",
            "TERM": "xterm",
            "USER": "root",
            "USERNAME": "root",
            "XDG_SESSION_ID": "12",
            "_": "/usr/bin/python3.7"
        },
        "eth0": {
            "active": true,
            "device": "eth0",
            "features": {
                "esp_hw_offload": "off [fixed]",
                "esp_tx_csum_hw_offload": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "off [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "off [fixed]",
                "netns_local": "off [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off [fixed]",
                "rx_checksumming": "on [fixed]",
                "rx_fcs": "off [fixed]",
                "rx_udp_tunnel_port_offload": "off [fixed]",
                "rx_vlan_filter": "off [fixed]",
                "rx_vlan_offload": "off [fixed]",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "off [fixed]",
                "tx_checksum_ipv4": "on [fixed]",
                "tx_checksum_ipv6": "on",
                "tx_checksum_sctp": "off [fixed]",
                "tx_checksumming": "on",
                "tx_esp_segmentation": "off [fixed]",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "on [fixed]",
                "tx_ipxip4_segmentation": "off [fixed]",
                "tx_ipxip6_segmentation": "off [fixed]",
                "tx_lockless": "off [fixed]",
                "tx_nocache_copy": "off",
                "tx_scatter_gather": "on",
                "tx_scatter_gather_fraglist": "off [fixed]",
                "tx_sctp_segmentation": "off [fixed]",
                "tx_tcp6_segmentation": "on",
                "tx_tcp_ecn_segmentation": "off [fixed]",
                "tx_tcp_mangleid_segmentation": "off",
                "tx_tcp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "off [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "udp_fragmentation_offload": "off",
                "vlan_challenged": "off [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "10.222.0.15",
                "broadcast": "10.222.0.255",
                "netmask": "255.255.255.0",
                "network": "10.222.0.0"
            },
            "ipv6": [
                {
                    "address": "fe80::71:7bff:fe2d:ccb8",
                    "prefix": "64",
                    "scope": "link"
                }
            ],
            "macaddress": "02:71:7b:2d:cc:b8",
            "module": "xen_netfront",
            "mtu": 9001,
            "pciid": "vif-0",
            "promisc": false,
            "timestamping": [
                "rx_software",
                "software"
            ],
            "type": "ether"
        },
        "fibre_channel_wwn": [],
        "fips": false,
        "form_factor": "Other",
        "fqdn": "ip-10-222-0-15.ap-northeast-2.compute.internal",
        "gather_subset": [
            "all"
        ],
        "hostname": "ip-10-222-0-15",
        "hostnqn": "",
        "interfaces": [
            "lo",
            "eth0"
        ],
        "is_chroot": false,
        "iscsi_iqn": "",
        "kernel": "4.14.268-205.500.amzn2.x86_64",
        "kernel_version": "#1 SMP Wed Mar 2 18:38:38 UTC 2022",
        "lo": {
            "active": true,
            "device": "lo",
            "features": {
                "esp_hw_offload": "off [fixed]",
                "esp_tx_csum_hw_offload": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "on [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "on [fixed]",
                "netns_local": "on [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off [fixed]",
                "rx_checksumming": "on [fixed]",
                "rx_fcs": "off [fixed]",
                "rx_udp_tunnel_port_offload": "off [fixed]",
                "rx_vlan_filter": "off [fixed]",
                "rx_vlan_offload": "off [fixed]",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "on [fixed]",
                "tx_checksum_ipv4": "off [fixed]",
                "tx_checksum_ipv6": "off [fixed]",
                "tx_checksum_sctp": "on [fixed]",
                "tx_checksumming": "on",
                "tx_esp_segmentation": "off [fixed]",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "off [fixed]",
                "tx_ipxip4_segmentation": "off [fixed]",
                "tx_ipxip6_segmentation": "off [fixed]",
                "tx_lockless": "on [fixed]",
                "tx_nocache_copy": "off [fixed]",
                "tx_scatter_gather": "on [fixed]",
                "tx_scatter_gather_fraglist": "on [fixed]",
                "tx_sctp_segmentation": "on",
                "tx_tcp6_segmentation": "on",
                "tx_tcp_ecn_segmentation": "on",
                "tx_tcp_mangleid_segmentation": "on",
                "tx_tcp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "off [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "udp_fragmentation_offload": "off",
                "vlan_challenged": "on [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "127.0.0.1",
                "broadcast": "",
                "netmask": "255.0.0.0",
                "network": "127.0.0.0"
            },
            "ipv6": [
                {
                    "address": "::1",
                    "prefix": "128",
                    "scope": "host"
                }
            ],
            "mtu": 65536,
            "promisc": false,
            "timestamping": [
                "tx_software",
                "rx_software",
                "software"
            ],
            "type": "loopback"
        },
        "lsb": {},
        "lvm": {
            "lvs": {},
            "pvs": {},
            "vgs": {}
        },
        "machine": "x86_64",
        "machine_id": "ec241e799eaf2c0ee222f87da91ab53c",
        "memfree_mb": 298,
        "memory_mb": {
            "nocache": {
                "free": 818,
                "used": 164
            },
            "real": {
                "free": 298,
                "total": 982,
                "used": 684
            },
            "swap": {
                "cached": 0,
                "free": 0,
                "total": 0,
                "used": 0
            }
        },
        "memtotal_mb": 982,
        "module_setup": true,
        "mounts": [
            {
                "block_available": 1697591,
                "block_size": 4096,
                "block_total": 2094075,
                "block_used": 396484,
                "device": "/dev/xvda1",
                "fstype": "xfs",
                "inode_available": 4143569,
                "inode_total": 4193216,
                "inode_used": 49647,
                "mount": "/",
                "options": "rw,noatime,attr2,inode64,noquota",
                "size_available": 6953332736,
                "size_total": 8577331200,
                "uuid": "dc74d1d7-c6e7-4592-931f-70681a786a83"
            }
        ],
        "nodename": "ip-10-222-0-15.ap-northeast-2.compute.internal",
        "os_family": "RedHat",
        "pkg_mgr": "yum",
        "proc_cmdline": {
            "BOOT_IMAGE": "/boot/vmlinuz-4.14.268-205.500.amzn2.x86_64",
            "biosdevname": "0",
            "console": [
                "tty0",
                "ttyS0,115200n8"
            ],
            "net.ifnames": "0",
            "nvme_core.io_timeout": "4294967295",
            "rd.emergency": "poweroff",
            "rd.shell": "0",
            "ro": true,
            "root": "UUID=dc74d1d7-c6e7-4592-931f-70681a786a83"
        },
        "processor": [
            "0",
            "GenuineIntel",
            "Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz"
        ],
        "processor_cores": 1,
        "processor_count": 1,
        "processor_nproc": 1,
        "processor_threads_per_core": 1,
        "processor_vcpus": 1,
        "product_name": "HVM domU",
        "product_serial": "ec25dfa0-28cb-e236-20e2-f5817b673c2e",
        "product_uuid": "EC25DFA0-28CB-E236-20E2-F5817B673C2E",
        "product_version": "4.11.amazon",
        "python": {
            "executable": "/usr/bin/python3.7",
            "has_sslcontext": true,
            "type": "cpython",
            "version": {
                "major": 3,
                "micro": 10,
                "minor": 7,
                "releaselevel": "final",
                "serial": 0
            },
            "version_info": [
                3,
                7,
                10,
                "final",
                0
            ]
        },
        "python_version": "3.7.10",
        "real_group_id": 0,
        "real_user_id": 0,
        "selinux": {
            "status": "disabled"
        },
        "selinux_python_present": true,
        "service_mgr": "systemd",
        "ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCts487wBdmBi7z4lc2aj/lTai6aevOn05dgF9zghoGCt8Spplq8FlWt6u4x9hPHozJXfi5fMbFGQv7eVojfl3E=",
        "ssh_host_key_ecdsa_public_keytype": "ecdsa-sha2-nistp256",
        "ssh_host_key_ed25519_public": "AAAAC3NzaC1lZDI1NTE5AAAAIMvUh2Z8l07n5KVxIUDWti9lNutIPNbRN7WcDhEDWiPD",
        "ssh_host_key_ed25519_public_keytype": "ssh-ed25519",
        "ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABAQCu7ncyCq7y/wLrVIn5E+CVSIXwMu1gb9Pp127M40KYw5UjWAaV2AK3uqCZxzX2pWWHYgxqms9A3wORNMZpcsrcMx446xNsMRmmVA/vGBW4PwoENRq3dFg51VLAQQOwja2EQdxsNfoUgVBR4VGLNwyPQff4d5ZQwPviTZONQo8ErLsLpkYRrAgkAbMFDGa5o5nXLB3TzLjfDeVycbRkv3dATC3aoDxGB+lg76pxTrQDcfPujKv9xrN+IAcbelsJZ+oaRjQJA7bBJVlt/EyOOJsMPhs8zxeV+cQyCDnLo6WwwpzEORo6ipx0IVH+73L4robfWQf/Z1i1V4CO2ESIh1LJ",
        "ssh_host_key_rsa_public_keytype": "ssh-rsa",
        "swapfree_mb": 0,
        "swaptotal_mb": 0,
        "system": "Linux",
        "system_capabilities": [
            "cap_chown",
            "cap_dac_override",
            "cap_dac_read_search",
            "cap_fowner",
            "cap_fsetid",
            "cap_kill",
            "cap_setgid",
            "cap_setuid",
            "cap_setpcap",
            "cap_linux_immutable",
            "cap_net_bind_service",
            "cap_net_broadcast",
            "cap_net_admin",
            "cap_net_raw",
            "cap_ipc_lock",
            "cap_ipc_owner",
            "cap_sys_module",
            "cap_sys_rawio",
            "cap_sys_chroot",
            "cap_sys_ptrace",
            "cap_sys_pacct",
            "cap_sys_admin",
            "cap_sys_boot",
            "cap_sys_nice",
            "cap_sys_resource",
            "cap_sys_time",
            "cap_sys_tty_config",
            "cap_mknod",
            "cap_lease",
            "cap_audit_write",
            "cap_audit_control",
            "cap_setfcap",
            "cap_mac_override",
            "cap_mac_admin",
            "cap_syslog",
            "35",
            "36",
            "37+ep"
        ],
        "system_capabilities_enforced": "True",
        "system_vendor": "Xen",
        "uptime_seconds": 4213,
        "user_dir": "/root",
        "user_gecos": "root",
        "user_gid": 0,
        "user_id": "root",
        "user_shell": "/bin/bash",
        "user_uid": 0,
        "userspace_architecture": "x86_64",
        "userspace_bits": "64",
        "virtualization_role": "guest",
        "virtualization_tech_guest": [
            "xen"
        ],
        "virtualization_tech_host": [],
        "virtualization_type": "xen"
    }
}
ok: [amazon2] => {
    "ansible_facts": {
        "all_ipv4_addresses": [
            "10.222.0.49"
        ],
        "all_ipv6_addresses": [
            "fe80::7d:bff:fe25:74d0"
        ],
        "ansible_local": {},
        "apparmor": {
            "status": "disabled"
        },
        "architecture": "x86_64",
        "bios_date": "08/24/2006",
        "bios_vendor": "Xen",
        "bios_version": "4.11.amazon",
        "board_asset_tag": "NA",
        "board_name": "NA",
        "board_serial": "NA",
        "board_vendor": "NA",
        "board_version": "NA",
        "chassis_asset_tag": "NA",
        "chassis_serial": "NA",
        "chassis_vendor": "Xen",
        "chassis_version": "NA",
        "cmdline": {
            "BOOT_IMAGE": "/boot/vmlinuz-4.14.268-205.500.amzn2.x86_64",
            "biosdevname": "0",
            "console": "ttyS0,115200n8",
            "net.ifnames": "0",
            "nvme_core.io_timeout": "4294967295",
            "rd.emergency": "poweroff",
            "rd.shell": "0",
            "ro": true,
            "root": "UUID=dc74d1d7-c6e7-4592-931f-70681a786a83"
        },
        "date_time": {
            "date": "2022-03-27",
            "day": "27",
            "epoch": "1648352759",
            "epoch_int": "1648352759",
            "hour": "03",
            "iso8601": "2022-03-27T03:45:59Z",
            "iso8601_basic": "20220327T034559417158",
            "iso8601_basic_short": "20220327T034559",
            "iso8601_micro": "2022-03-27T03:45:59.417158Z",
            "minute": "45",
            "month": "03",
            "second": "59",
            "time": "03:45:59",
            "tz": "UTC",
            "tz_dst": "UTC",
            "tz_offset": "+0000",
            "weekday": "Sunday",
            "weekday_number": "0",
            "weeknumber": "12",
            "year": "2022"
        },
        "default_ipv4": {
            "address": "10.222.0.49",
            "alias": "eth0",
            "broadcast": "10.222.0.255",
            "gateway": "10.222.0.1",
            "interface": "eth0",
            "macaddress": "02:7d:0b:25:74:d0",
            "mtu": 9001,
            "netmask": "255.255.255.0",
            "network": "10.222.0.0",
            "type": "ether"
        },
        "default_ipv6": {},
        "device_links": {
            "ids": {},
            "labels": {
                "xvda1": [
                    "\\x2f"
                ]
            },
            "masters": {},
            "uuids": {
                "xvda1": [
                    "dc74d1d7-c6e7-4592-931f-70681a786a83"
                ]
            }
        },
        "devices": {
            "xvda": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {
                    "xvda1": {
                        "holders": [],
                        "links": {
                            "ids": [],
                            "labels": [
                                "\\x2f"
                            ],
                            "masters": [],
                            "uuids": [
                                "dc74d1d7-c6e7-4592-931f-70681a786a83"
                            ]
                        },
                        "sectors": "16773087",
                        "sectorsize": 512,
                        "size": "8.00 GB",
                        "start": "4096",
                        "uuid": "dc74d1d7-c6e7-4592-931f-70681a786a83"
                    }
                },
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "noop",
                "sectors": "16777216",
                "sectorsize": "512",
                "size": "8.00 GB",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            }
        },
        "discovered_interpreter_python": "/usr/bin/python3.7",
        "distribution": "Amazon",
        "distribution_file_parsed": true,
        "distribution_file_path": "/etc/os-release",
        "distribution_file_variety": "Amazon",
        "distribution_major_version": "2",
        "distribution_minor_version": "NA",
        "distribution_release": "NA",
        "distribution_version": "2",
        "dns": {
            "nameservers": [
                "10.222.0.2"
            ],
            "options": {
                "attempts": "5",
                "timeout": "2"
            },
            "search": [
                "ap-northeast-2.compute.internal"
            ]
        },
        "domain": "ap-northeast-2.compute.internal",
        "effective_group_id": 0,
        "effective_user_id": 0,
        "env": {
            "HOME": "/root",
            "LANG": "en_US.UTF-8",
            "LOGNAME": "root",
            "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:",
            "MAIL": "/var/mail/ec2-user",
            "PATH": "/sbin:/bin:/usr/sbin:/usr/bin",
            "PWD": "/home/ec2-user",
            "SHELL": "/bin/bash",
            "SHLVL": "1",
            "SUDO_COMMAND": "/bin/sh -c echo BECOME-SUCCESS-gjelubhnhblihvpwbunqowiyryovtncp ; /usr/bin/python3.7 /home/ec2-user/.ansible/tmp/ansible-tmp-1648352758.6574352-1826208-46332072141723/AnsiballZ_setup.py",
            "SUDO_GID": "1000",
            "SUDO_UID": "1000",
            "SUDO_USER": "ec2-user",
            "TERM": "xterm",
            "USER": "root",
            "USERNAME": "root",
            "XDG_SESSION_ID": "12",
            "_": "/usr/bin/python3.7"
        },
        "eth0": {
            "active": true,
            "device": "eth0",
            "features": {
                "esp_hw_offload": "off [fixed]",
                "esp_tx_csum_hw_offload": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "off [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "off [fixed]",
                "netns_local": "off [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off [fixed]",
                "rx_checksumming": "on [fixed]",
                "rx_fcs": "off [fixed]",
                "rx_udp_tunnel_port_offload": "off [fixed]",
                "rx_vlan_filter": "off [fixed]",
                "rx_vlan_offload": "off [fixed]",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "off [fixed]",
                "tx_checksum_ipv4": "on [fixed]",
                "tx_checksum_ipv6": "on",
                "tx_checksum_sctp": "off [fixed]",
                "tx_checksumming": "on",
                "tx_esp_segmentation": "off [fixed]",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "on [fixed]",
                "tx_ipxip4_segmentation": "off [fixed]",
                "tx_ipxip6_segmentation": "off [fixed]",
                "tx_lockless": "off [fixed]",
                "tx_nocache_copy": "off",
                "tx_scatter_gather": "on",
                "tx_scatter_gather_fraglist": "off [fixed]",
                "tx_sctp_segmentation": "off [fixed]",
                "tx_tcp6_segmentation": "on",
                "tx_tcp_ecn_segmentation": "off [fixed]",
                "tx_tcp_mangleid_segmentation": "off",
                "tx_tcp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "off [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "udp_fragmentation_offload": "off",
                "vlan_challenged": "off [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "10.222.0.49",
                "broadcast": "10.222.0.255",
                "netmask": "255.255.255.0",
                "network": "10.222.0.0"
            },
            "ipv6": [
                {
                    "address": "fe80::7d:bff:fe25:74d0",
                    "prefix": "64",
                    "scope": "link"
                }
            ],
            "macaddress": "02:7d:0b:25:74:d0",
            "module": "xen_netfront",
            "mtu": 9001,
            "pciid": "vif-0",
            "promisc": false,
            "timestamping": [
                "rx_software",
                "software"
            ],
            "type": "ether"
        },
        "fibre_channel_wwn": [],
        "fips": false,
        "form_factor": "Other",
        "fqdn": "ip-10-222-0-49.ap-northeast-2.compute.internal",
        "gather_subset": [
            "all"
        ],
        "hostname": "ip-10-222-0-49",
        "hostnqn": "",
        "interfaces": [
            "eth0",
            "lo"
        ],
        "is_chroot": false,
        "iscsi_iqn": "",
        "kernel": "4.14.268-205.500.amzn2.x86_64",
        "kernel_version": "#1 SMP Wed Mar 2 18:38:38 UTC 2022",
        "lo": {
            "active": true,
            "device": "lo",
            "features": {
                "esp_hw_offload": "off [fixed]",
                "esp_tx_csum_hw_offload": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "on [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "on [fixed]",
                "netns_local": "on [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off [fixed]",
                "rx_checksumming": "on [fixed]",
                "rx_fcs": "off [fixed]",
                "rx_udp_tunnel_port_offload": "off [fixed]",
                "rx_vlan_filter": "off [fixed]",
                "rx_vlan_offload": "off [fixed]",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "on [fixed]",
                "tx_checksum_ipv4": "off [fixed]",
                "tx_checksum_ipv6": "off [fixed]",
                "tx_checksum_sctp": "on [fixed]",
                "tx_checksumming": "on",
                "tx_esp_segmentation": "off [fixed]",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "off [fixed]",
                "tx_ipxip4_segmentation": "off [fixed]",
                "tx_ipxip6_segmentation": "off [fixed]",
                "tx_lockless": "on [fixed]",
                "tx_nocache_copy": "off [fixed]",
                "tx_scatter_gather": "on [fixed]",
                "tx_scatter_gather_fraglist": "on [fixed]",
                "tx_sctp_segmentation": "on",
                "tx_tcp6_segmentation": "on",
                "tx_tcp_ecn_segmentation": "on",
                "tx_tcp_mangleid_segmentation": "on",
                "tx_tcp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "off [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "udp_fragmentation_offload": "off",
                "vlan_challenged": "on [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "127.0.0.1",
                "broadcast": "",
                "netmask": "255.0.0.0",
                "network": "127.0.0.0"
            },
            "ipv6": [
                {
                    "address": "::1",
                    "prefix": "128",
                    "scope": "host"
                }
            ],
            "mtu": 65536,
            "promisc": false,
            "timestamping": [
                "tx_software",
                "rx_software",
                "software"
            ],
            "type": "loopback"
        },
        "lsb": {},
        "lvm": {
            "lvs": {},
            "pvs": {},
            "vgs": {}
        },
        "machine": "x86_64",
        "machine_id": "ec241e799eaf2c0ee222f87da91ab53c",
        "memfree_mb": 364,
        "memory_mb": {
            "nocache": {
                "free": 847,
                "used": 135
            },
            "real": {
                "free": 364,
                "total": 982,
                "used": 618
            },
            "swap": {
                "cached": 0,
                "free": 0,
                "total": 0,
                "used": 0
            }
        },
        "memtotal_mb": 982,
        "module_setup": true,
        "mounts": [
            {
                "block_available": 1698247,
                "block_size": 4096,
                "block_total": 2094075,
                "block_used": 395828,
                "device": "/dev/xvda1",
                "fstype": "xfs",
                "inode_available": 4143710,
                "inode_total": 4193216,
                "inode_used": 49506,
                "mount": "/",
                "options": "rw,noatime,attr2,inode64,noquota",
                "size_available": 6956019712,
                "size_total": 8577331200,
                "uuid": "dc74d1d7-c6e7-4592-931f-70681a786a83"
            }
        ],
        "nodename": "ip-10-222-0-49.ap-northeast-2.compute.internal",
        "os_family": "RedHat",
        "pkg_mgr": "yum",
        "proc_cmdline": {
            "BOOT_IMAGE": "/boot/vmlinuz-4.14.268-205.500.amzn2.x86_64",
            "biosdevname": "0",
            "console": [
                "tty0",
                "ttyS0,115200n8"
            ],
            "net.ifnames": "0",
            "nvme_core.io_timeout": "4294967295",
            "rd.emergency": "poweroff",
            "rd.shell": "0",
            "ro": true,
            "root": "UUID=dc74d1d7-c6e7-4592-931f-70681a786a83"
        },
        "processor": [
            "0",
            "GenuineIntel",
            "Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz"
        ],
        "processor_cores": 1,
        "processor_count": 1,
        "processor_nproc": 1,
        "processor_threads_per_core": 1,
        "processor_vcpus": 1,
        "product_name": "HVM domU",
        "product_serial": "ec2f7385-a588-dcdf-3ce6-409c0c6a1209",
        "product_uuid": "EC2F7385-A588-DCDF-3CE6-409C0C6A1209",
        "product_version": "4.11.amazon",
        "python": {
            "executable": "/usr/bin/python3.7",
            "has_sslcontext": true,
            "type": "cpython",
            "version": {
                "major": 3,
                "micro": 10,
                "minor": 7,
                "releaselevel": "final",
                "serial": 0
            },
            "version_info": [
                3,
                7,
                10,
                "final",
                0
            ]
        },
        "python_version": "3.7.10",
        "real_group_id": 0,
        "real_user_id": 0,
        "selinux": {
            "status": "disabled"
        },
        "selinux_python_present": true,
        "service_mgr": "systemd",
        "ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBADeJMrybBlNsqEfXBMgGAOpivRNkaPyuObxoKk0Bq4AqFX+aIhI9ds6ZISyrtVOrf9qZ080Q1u6Hb1n0VsvQmM=",
        "ssh_host_key_ecdsa_public_keytype": "ecdsa-sha2-nistp256",
        "ssh_host_key_ed25519_public": "AAAAC3NzaC1lZDI1NTE5AAAAINbHglVoi1tDCxjlE1R7leeVfFnE6OdoiilZtrTo7Kcc",
        "ssh_host_key_ed25519_public_keytype": "ssh-ed25519",
        "ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABAQDhD+sPivpP3dFLfVbgF8t+q4ipPImQ9NdeuZdZVeaaRlliifFnQDx9dZp1fWEIA/T+wRwVgAmuA6SNG/fSvOtTRB8j8xYCaAjh5Yu4VOnVhHJfXq/4qt/v3OzKd0SBSBSCuBExB5wDnaxoWDuq/CmhDEh0/V7hY6UtlCtlXGOkEEhexTatESIwXT56BVhkQvcXu719PADj3MLOtPnfMMDfHs9wFRumcDqSnTwsy8dia9fHOMoaiZv52W3D7PxBpmMIjPquzK8oF7YPvVlK9TclcmwvVzwGvL9rhPchYL1ZUw7gm8YRweego0hEwDiaIyu5drSQxl1jpyvs+b/RLLQh",
        "ssh_host_key_rsa_public_keytype": "ssh-rsa",
        "swapfree_mb": 0,
        "swaptotal_mb": 0,
        "system": "Linux",
        "system_capabilities": [
            "cap_chown",
            "cap_dac_override",
            "cap_dac_read_search",
            "cap_fowner",
            "cap_fsetid",
            "cap_kill",
            "cap_setgid",
            "cap_setuid",
            "cap_setpcap",
            "cap_linux_immutable",
            "cap_net_bind_service",
            "cap_net_broadcast",
            "cap_net_admin",
            "cap_net_raw",
            "cap_ipc_lock",
            "cap_ipc_owner",
            "cap_sys_module",
            "cap_sys_rawio",
            "cap_sys_chroot",
            "cap_sys_ptrace",
            "cap_sys_pacct",
            "cap_sys_admin",
            "cap_sys_boot",
            "cap_sys_nice",
            "cap_sys_resource",
            "cap_sys_time",
            "cap_sys_tty_config",
            "cap_mknod",
            "cap_lease",
            "cap_audit_write",
            "cap_audit_control",
            "cap_setfcap",
            "cap_mac_override",
            "cap_mac_admin",
            "cap_syslog",
            "35",
            "36",
            "37+ep"
        ],
        "system_capabilities_enforced": "True",
        "system_vendor": "Xen",
        "uptime_seconds": 4217,
        "user_dir": "/root",
        "user_gecos": "root",
        "user_gid": 0,
        "user_id": "root",
        "user_shell": "/bin/bash",
        "user_uid": 0,
        "userspace_architecture": "x86_64",
        "userspace_bits": "64",
        "virtualization_role": "guest",
        "virtualization_tech_guest": [
            "xen"
        ],
        "virtualization_tech_host": [],
        "virtualization_type": "xen"
    }
}
ok: [ubuntu1] => {
    "ansible_facts": {
        "all_ipv4_addresses": [
            "10.222.0.193"
        ],
        "all_ipv6_addresses": [
            "fe80::19:61ff:fe74:707c"
        ],
        "ansible_local": {},
        "apparmor": {
            "status": "enabled"
        },
        "architecture": "x86_64",
        "bios_date": "08/24/2006",
        "bios_vendor": "Xen",
        "bios_version": "4.11.amazon",
        "board_asset_tag": "NA",
        "board_name": "NA",
        "board_serial": "NA",
        "board_vendor": "NA",
        "board_version": "NA",
        "chassis_asset_tag": "NA",
        "chassis_serial": "NA",
        "chassis_vendor": "Xen",
        "chassis_version": "NA",
        "cmdline": {
            "BOOT_IMAGE": "/boot/vmlinuz-5.13.0-1019-aws",
            "console": "ttyS0",
            "nvme_core.io_timeout": "4294967295",
            "panic": "-1",
            "ro": true,
            "root": "PARTUUID=0f6f1620-01"
        },
        "date_time": {
            "date": "2022-03-27",
            "day": "27",
            "epoch": "1648352759",
            "epoch_int": "1648352759",
            "hour": "03",
            "iso8601": "2022-03-27T03:45:59Z",
            "iso8601_basic": "20220327T034559556788",
            "iso8601_basic_short": "20220327T034559",
            "iso8601_micro": "2022-03-27T03:45:59.556788Z",
            "minute": "45",
            "month": "03",
            "second": "59",
            "time": "03:45:59",
            "tz": "UTC",
            "tz_dst": "UTC",
            "tz_offset": "+0000",
            "weekday": "Sunday",
            "weekday_number": "0",
            "weeknumber": "12",
            "year": "2022"
        },
        "default_ipv4": {
            "address": "10.222.0.193",
            "alias": "eth0",
            "broadcast": "10.222.0.255",
            "gateway": "10.222.0.1",
            "interface": "eth0",
            "macaddress": "02:19:61:74:70:7c",
            "mtu": 9001,
            "netmask": "255.255.255.0",
            "network": "10.222.0.0",
            "type": "ether"
        },
        "default_ipv6": {},
        "device_links": {
            "ids": {},
            "labels": {
                "xvda1": [
                    "cloudimg-rootfs"
                ]
            },
            "masters": {},
            "uuids": {
                "xvda1": [
                    "f8be84fd-5f1b-4666-ad0d-3cabfdcae49d"
                ]
            }
        },
        "devices": {
            "loop0": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "54552",
                "sectorsize": "512",
                "size": "26.64 MB",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop1": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "113696",
                "sectorsize": "512",
                "size": "55.52 MB",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop2": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "126760",
                "sectorsize": "512",
                "size": "61.89 MB",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop3": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "139104",
                "sectorsize": "512",
                "size": "67.92 MB",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop4": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "89352",
                "sectorsize": "512",
                "size": "43.63 MB",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop5": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop6": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "loop7": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "xvda": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {
                    "xvda1": {
                        "holders": [],
                        "links": {
                            "ids": [],
                            "labels": [
                                "cloudimg-rootfs"
                            ],
                            "masters": [],
                            "uuids": [
                                "f8be84fd-5f1b-4666-ad0d-3cabfdcae49d"
                            ]
                        },
                        "sectors": "16775135",
                        "sectorsize": 512,
                        "size": "8.00 GB",
                        "start": "2048",
                        "uuid": "f8be84fd-5f1b-4666-ad0d-3cabfdcae49d"
                    }
                },
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "16777216",
                "sectorsize": "512",
                "size": "8.00 GB",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            }
        },
        "discovered_interpreter_python": "/usr/bin/python3",
        "distribution": "Ubuntu",
        "distribution_file_parsed": true,
        "distribution_file_path": "/etc/os-release",
        "distribution_file_variety": "Debian",
        "distribution_major_version": "20",
        "distribution_release": "focal",
        "distribution_version": "20.04",
        "dns": {
            "nameservers": [
                "127.0.0.53"
            ],
            "options": {
                "edns0": true,
                "trust-ad": true
            },
            "search": [
                "ap-northeast-2.compute.internal"
            ]
        },
        "domain": "ap-northeast-2.compute.internal",
        "effective_group_id": 0,
        "effective_user_id": 0,
        "env": {
            "HOME": "/root",
            "LANG": "C.UTF-8",
            "LOGNAME": "root",
            "MAIL": "/var/mail/root",
            "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin",
            "PWD": "/home/ubuntu",
            "SHELL": "/bin/bash",
            "SUDO_COMMAND": "/bin/sh -c echo BECOME-SUCCESS-ayyvwnontfgrvlxkvlvyhtrwjpjbkgfx ; /usr/bin/python3 /home/ubuntu/.ansible/tmp/ansible-tmp-1648352758.6547112-1826210-37927904610157/AnsiballZ_setup.py",
            "SUDO_GID": "1000",
            "SUDO_UID": "1000",
            "SUDO_USER": "ubuntu",
            "TERM": "xterm",
            "USER": "root"
        },
        "eth0": {
            "active": true,
            "device": "eth0",
            "features": {
                "esp_hw_offload": "off [fixed]",
                "esp_tx_csum_hw_offload": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "off [fixed]",
                "hsr_dup_offload": "off [fixed]",
                "hsr_fwd_offload": "off [fixed]",
                "hsr_tag_ins_offload": "off [fixed]",
                "hsr_tag_rm_offload": "off [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "off [fixed]",
                "macsec_hw_offload": "off [fixed]",
                "netns_local": "off [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off [fixed]",
                "rx_checksumming": "on [fixed]",
                "rx_fcs": "off [fixed]",
                "rx_gro_hw": "off [fixed]",
                "rx_gro_list": "off",
                "rx_udp_gro_forwarding": "off",
                "rx_udp_tunnel_port_offload": "off [fixed]",
                "rx_vlan_filter": "off [fixed]",
                "rx_vlan_offload": "off [fixed]",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tls_hw_record": "off [fixed]",
                "tls_hw_rx_offload": "off [fixed]",
                "tls_hw_tx_offload": "off [fixed]",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "off [fixed]",
                "tx_checksum_ipv4": "on [fixed]",
                "tx_checksum_ipv6": "on",
                "tx_checksum_sctp": "off [fixed]",
                "tx_checksumming": "on",
                "tx_esp_segmentation": "off [fixed]",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_list": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "on [fixed]",
                "tx_ipxip4_segmentation": "off [fixed]",
                "tx_ipxip6_segmentation": "off [fixed]",
                "tx_lockless": "off [fixed]",
                "tx_nocache_copy": "off",
                "tx_scatter_gather": "on",
                "tx_scatter_gather_fraglist": "off [fixed]",
                "tx_sctp_segmentation": "off [fixed]",
                "tx_tcp6_segmentation": "on",
                "tx_tcp_ecn_segmentation": "off [fixed]",
                "tx_tcp_mangleid_segmentation": "off",
                "tx_tcp_segmentation": "on",
                "tx_tunnel_remcsum_segmentation": "off [fixed]",
                "tx_udp_segmentation": "off [fixed]",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "off [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "vlan_challenged": "off [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "10.222.0.193",
                "broadcast": "10.222.0.255",
                "netmask": "255.255.255.0",
                "network": "10.222.0.0"
            },
            "ipv6": [
                {
                    "address": "fe80::19:61ff:fe74:707c",
                    "prefix": "64",
                    "scope": "link"
                }
            ],
            "macaddress": "02:19:61:74:70:7c",
            "module": "xen_netfront",
            "mtu": 9001,
            "pciid": "vif-0",
            "promisc": false,
            "timestamping": [
                "tx_software",
                "rx_software",
                "software"
            ],
            "type": "ether"
        },
        "fibre_channel_wwn": [],
        "fips": false,
        "form_factor": "Other",
        "fqdn": "ip-10-222-0-193.ap-northeast-2.compute.internal",
        "gather_subset": [
            "all"
        ],
        "hostname": "ip-10-222-0-193",
        "hostnqn": "",
        "interfaces": [
            "eth0",
            "lo"
        ],
        "is_chroot": false,
        "iscsi_iqn": "",
        "kernel": "5.13.0-1019-aws",
        "kernel_version": "#21~20.04.1-Ubuntu SMP Wed Mar 16 11:54:08 UTC 2022",
        "lo": {
            "active": true,
            "device": "lo",
            "features": {
                "esp_hw_offload": "off [fixed]",
                "esp_tx_csum_hw_offload": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "on [fixed]",
                "hsr_dup_offload": "off [fixed]",
                "hsr_fwd_offload": "off [fixed]",
                "hsr_tag_ins_offload": "off [fixed]",
                "hsr_tag_rm_offload": "off [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "on [fixed]",
                "macsec_hw_offload": "off [fixed]",
                "netns_local": "on [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off [fixed]",
                "rx_checksumming": "on [fixed]",
                "rx_fcs": "off [fixed]",
                "rx_gro_hw": "off [fixed]",
                "rx_gro_list": "off",
                "rx_udp_gro_forwarding": "off",
                "rx_udp_tunnel_port_offload": "off [fixed]",
                "rx_vlan_filter": "off [fixed]",
                "rx_vlan_offload": "off [fixed]",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tls_hw_record": "off [fixed]",
                "tls_hw_rx_offload": "off [fixed]",
                "tls_hw_tx_offload": "off [fixed]",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "on [fixed]",
                "tx_checksum_ipv4": "off [fixed]",
                "tx_checksum_ipv6": "off [fixed]",
                "tx_checksum_sctp": "on [fixed]",
                "tx_checksumming": "on",
                "tx_esp_segmentation": "off [fixed]",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_list": "on",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "off [fixed]",
                "tx_ipxip4_segmentation": "off [fixed]",
                "tx_ipxip6_segmentation": "off [fixed]",
                "tx_lockless": "on [fixed]",
                "tx_nocache_copy": "off [fixed]",
                "tx_scatter_gather": "on [fixed]",
                "tx_scatter_gather_fraglist": "on [fixed]",
                "tx_sctp_segmentation": "on",
                "tx_tcp6_segmentation": "on",
                "tx_tcp_ecn_segmentation": "on",
                "tx_tcp_mangleid_segmentation": "on",
                "tx_tcp_segmentation": "on",
                "tx_tunnel_remcsum_segmentation": "off [fixed]",
                "tx_udp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "off [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "vlan_challenged": "on [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "127.0.0.1",
                "broadcast": "",
                "netmask": "255.0.0.0",
                "network": "127.0.0.0"
            },
            "ipv6": [
                {
                    "address": "::1",
                    "prefix": "128",
                    "scope": "host"
                }
            ],
            "mtu": 65536,
            "promisc": false,
            "timestamping": [
                "tx_software",
                "rx_software",
                "software"
            ],
            "type": "loopback"
        },
        "lsb": {
            "codename": "focal",
            "description": "Ubuntu 20.04.4 LTS",
            "id": "Ubuntu",
            "major_release": "20",
            "release": "20.04"
        },
        "lvm": {
            "lvs": {},
            "pvs": {},
            "vgs": {}
        },
        "machine": "x86_64",
        "machine_id": "0d630c36716748cca77e33e6a49ae863",
        "memfree_mb": 210,
        "memory_mb": {
            "nocache": {
                "free": 767,
                "used": 200
            },
            "real": {
                "free": 210,
                "total": 967,
                "used": 757
            },
            "swap": {
                "cached": 0,
                "free": 0,
                "total": 0,
                "used": 0
            }
        },
        "memtotal_mb": 967,
        "module_setup": true,
        "mounts": [
            {
                "block_available": 1594291,
                "block_size": 4096,
                "block_total": 2016361,
                "block_used": 422070,
                "device": "/dev/root",
                "fstype": "ext4",
                "inode_available": 953863,
                "inode_total": 1024000,
                "inode_used": 70137,
                "mount": "/",
                "options": "rw,relatime,discard",
                "size_available": 6530215936,
                "size_total": 8259014656,
                "uuid": "f8be84fd-5f1b-4666-ad0d-3cabfdcae49d"
            },
            {
                "block_available": 0,
                "block_size": 131072,
                "block_total": 496,
                "block_used": 496,
                "device": "/dev/loop2",
                "fstype": "squashfs",
                "inode_available": 0,
                "inode_total": 11777,
                "inode_used": 11777,
                "mount": "/snap/core20/1376",
                "options": "ro,nodev,relatime",
                "size_available": 0,
                "size_total": 65011712,
                "uuid": "N/A"
            },
            {
                "block_available": 0,
                "block_size": 131072,
                "block_total": 544,
                "block_used": 544,
                "device": "/dev/loop3",
                "fstype": "squashfs",
                "inode_available": 0,
                "inode_total": 799,
                "inode_used": 799,
                "mount": "/snap/lxd/22526",
                "options": "ro,nodev,relatime",
                "size_available": 0,
                "size_total": 71303168,
                "uuid": "N/A"
            },
            {
                "block_available": 0,
                "block_size": 131072,
                "block_total": 214,
                "block_used": 214,
                "device": "/dev/loop0",
                "fstype": "squashfs",
                "inode_available": 0,
                "inode_total": 16,
                "inode_used": 16,
                "mount": "/snap/amazon-ssm-agent/5163",
                "options": "ro,nodev,relatime",
                "size_available": 0,
                "size_total": 28049408,
                "uuid": "N/A"
            },
            {
                "block_available": 0,
                "block_size": 131072,
                "block_total": 445,
                "block_used": 445,
                "device": "/dev/loop1",
                "fstype": "squashfs",
                "inode_available": 0,
                "inode_total": 10849,
                "inode_used": 10849,
                "mount": "/snap/core18/2344",
                "options": "ro,nodev,relatime",
                "size_available": 0,
                "size_total": 58327040,
                "uuid": "N/A"
            },
            {
                "block_available": 0,
                "block_size": 131072,
                "block_total": 350,
                "block_used": 350,
                "device": "/dev/loop4",
                "fstype": "squashfs",
                "inode_available": 0,
                "inode_total": 482,
                "inode_used": 482,
                "mount": "/snap/snapd/15177",
                "options": "ro,nodev,relatime",
                "size_available": 0,
                "size_total": 45875200,
                "uuid": "N/A"
            }
        ],
        "nodename": "ip-10-222-0-193",
        "os_family": "Debian",
        "pkg_mgr": "apt",
        "proc_cmdline": {
            "BOOT_IMAGE": "/boot/vmlinuz-5.13.0-1019-aws",
            "console": [
                "tty1",
                "ttyS0"
            ],
            "nvme_core.io_timeout": "4294967295",
            "panic": "-1",
            "ro": true,
            "root": "PARTUUID=0f6f1620-01"
        },
        "processor": [
            "0",
            "GenuineIntel",
            "Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz"
        ],
        "processor_cores": 1,
        "processor_count": 1,
        "processor_nproc": 1,
        "processor_threads_per_core": 1,
        "processor_vcpus": 1,
        "product_name": "HVM domU",
        "product_serial": "ec2b41e2-159c-c81b-0f19-3659ca8e9cf1",
        "product_uuid": "ec2b41e2-159c-c81b-0f19-3659ca8e9cf1",
        "product_version": "4.11.amazon",
        "python": {
            "executable": "/usr/bin/python3",
            "has_sslcontext": true,
            "type": "cpython",
            "version": {
                "major": 3,
                "micro": 10,
                "minor": 8,
                "releaselevel": "final",
                "serial": 0
            },
            "version_info": [
                3,
                8,
                10,
                "final",
                0
            ]
        },
        "python_version": "3.8.10",
        "real_group_id": 0,
        "real_user_id": 0,
        "selinux": {
            "status": "disabled"
        },
        "selinux_python_present": true,
        "service_mgr": "systemd",
        "ssh_host_key_dsa_public": "AAAAB3NzaC1kc3MAAACBAMu6pC9CFyEMq5Uxh1LZFyKZM/a1uYQZtJNLrRHQsEvLmPhOOoPF9PvBzZ+1VhUWrXoKMRg9/Vf4pHGJdEFuGhphwgWWNbCtWDb6tfcdaYoRe4/Ax1tVgYvAnANd9X9FJDPxADC/Jndci3yzflt4gm0Psovae+0mE6OD9KF8/jPhAAAAFQCJEAh0LEMqS+H0pdgEMSpi9RZ6kwAAAIEAiUWQIC3Tphq34whaEcfN19XYPMlVGsW8f2jW5dIplWP3kfSjX1SsTEwlSUo1JLgpxg1H5GmzPoVM7sx/yOZYOmsq9WPrp7vHiNj9ZthYXBROr/wgol3+XEgZ5B039HK5O//uuiEIZZX8jdhrUi8IZQy7AwA7anvu/KtSrj8S3hUAAACBALh2S8ufw17vrGrooZxRKeRETNCXmYdqP0Cyhh27+y7BqgYkWfGurXzCnsXfU2GVz7nzjTy8CRAl6xZKSjMclceFc/gea0KXKAcfKNwm9Z1P00qSh9NwNRNoKTit536qr1ucl2fKvIK8QAox+oUDx8WtUWl/Njy0aDfgDEcp3sdi",
        "ssh_host_key_dsa_public_keytype": "ssh-dss",
        "ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMhGJCAiBCTKW/2amHiXaz4lJozZaoAIwjX3okfITawxD9jilEVufrBfB/uVUm9/XcRDcn0yen7B5EJ35OUB5LU=",
        "ssh_host_key_ecdsa_public_keytype": "ecdsa-sha2-nistp256",
        "ssh_host_key_ed25519_public": "AAAAC3NzaC1lZDI1NTE5AAAAINg18X0g5Ff7NN9GZOepDnqRg+Y+ctUxYzTInfjJgf/s",
        "ssh_host_key_ed25519_public_keytype": "ssh-ed25519",
        "ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABgQC6zDsbfRy4t8fQoMycle0tRikiCDdeqK5VgbUty2yT3H38Rx9YsfI/KgHgvD2hU+v+jt82u4NeHPyms9k2pMXGC043HeYWfV1/OftefFhmlzkj8CUg8TLvOkmHKTna8Hn8E36EHXb8Rndpi45HIc3whdmaCQHKpM5hFjtsJqIJLcyBPfDo7mrVt4hVVC4NU+5TRRJObRm6qHQApCJbGHQlc7InNk6uYElsRJiufZMaFqpD8okdC7a21xcuhBJdpsbyuOyIK2Tfo/HzqdfNk1ZBhNmF0ac4gDQqvAiPd84qf6N2rSudDgJk+AEhuWFqx5wb5YIH3vs7UWKxbXxCW3J/PC3wktDuJsfpE4Lb6SeAyefgDdkgyC9QCeHUJp1FhxZT9bqTfveBFn4aidL84v+Nz5I3e2yCfHQ1jZaYwwI7Y3MYUBIa0sD20TBUt/HhcF/u4dUNTlr1aXMeYrIDSFZHLwUBq3UhmMpUSMQiY2inOlfdYt6E9UXX8bFqdliA3d8=",
        "ssh_host_key_rsa_public_keytype": "ssh-rsa",
        "swapfree_mb": 0,
        "swaptotal_mb": 0,
        "system": "Linux",
        "system_capabilities": [],
        "system_capabilities_enforced": "False",
        "system_vendor": "Xen",
        "uptime_seconds": 4217,
        "user_dir": "/root",
        "user_gecos": "root",
        "user_gid": 0,
        "user_id": "root",
        "user_shell": "/bin/bash",
        "user_uid": 0,
        "userspace_architecture": "x86_64",
        "userspace_bits": "64",
        "virtualization_role": "guest",
        "virtualization_tech_guest": [
            "xen"
        ],
        "virtualization_tech_host": [],
        "virtualization_type": "xen"
    }
}
ok: [ubuntu2] => {
    "ansible_facts": {
        "all_ipv4_addresses": [
            "10.222.0.95"
        ],
        "all_ipv6_addresses": [
            "fe80::44:59ff:feb9:cd0e"
        ],
        "ansible_local": {},
        "apparmor": {
            "status": "enabled"
        },
        "architecture": "x86_64",
        "bios_date": "08/24/2006",
        "bios_vendor": "Xen",
        "bios_version": "4.11.amazon",
        "board_asset_tag": "NA",
        "board_name": "NA",
        "board_serial": "NA",
        "board_vendor": "NA",
        "board_version": "NA",
        "chassis_asset_tag": "NA",
        "chassis_serial": "NA",
        "chassis_vendor": "Xen",
        "chassis_version": "NA",
        "cmdline": {
            "BOOT_IMAGE": "/boot/vmlinuz-5.13.0-1019-aws",
            "console": "ttyS0",
            "nvme_core.io_timeout": "4294967295",
            "panic": "-1",
            "ro": true,
            "root": "PARTUUID=0f6f1620-01"
        },
        "date_time": {
            "date": "2022-03-27",
            "day": "27",
            "epoch": "1648352759",
            "epoch_int": "1648352759",
            "hour": "03",
            "iso8601": "2022-03-27T03:45:59Z",
            "iso8601_basic": "20220327T034559150184",
            "iso8601_basic_short": "20220327T034559",
            "iso8601_micro": "2022-03-27T03:45:59.150184Z",
            "minute": "45",
            "month": "03",
            "second": "59",
            "time": "03:45:59",
            "tz": "UTC",
            "tz_dst": "UTC",
            "tz_offset": "+0000",
            "weekday": "Sunday",
            "weekday_number": "0",
            "weeknumber": "12",
            "year": "2022"
        },
        "default_ipv4": {
            "address": "10.222.0.95",
            "alias": "eth0",
            "broadcast": "10.222.0.255",
            "gateway": "10.222.0.1",
            "interface": "eth0",
            "macaddress": "02:44:59:b9:cd:0e",
            "mtu": 9001,
            "netmask": "255.255.255.0",
            "network": "10.222.0.0",
            "type": "ether"
        },
        "default_ipv6": {},
        "device_links": {
            "ids": {},
            "labels": {
                "xvda1": [
                    "cloudimg-rootfs"
                ]
            },
            "masters": {},
            "uuids": {
                "xvda1": [
                    "f8be84fd-5f1b-4666-ad0d-3cabfdcae49d"
                ]
            }
        },
        "devices": {
            "loop0": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "54552",
                "sectorsize": "512",
                "size": "26.64 MB",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop1": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "113696",
                "sectorsize": "512",
                "size": "55.52 MB",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop2": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "126760",
                "sectorsize": "512",
                "size": "61.89 MB",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop3": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "139104",
                "sectorsize": "512",
                "size": "67.92 MB",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop4": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "89352",
                "sectorsize": "512",
                "size": "43.63 MB",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop5": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop6": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "loop7": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "xvda": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {
                    "xvda1": {
                        "holders": [],
                        "links": {
                            "ids": [],
                            "labels": [
                                "cloudimg-rootfs"
                            ],
                            "masters": [],
                            "uuids": [
                                "f8be84fd-5f1b-4666-ad0d-3cabfdcae49d"
                            ]
                        },
                        "sectors": "16775135",
                        "sectorsize": 512,
                        "size": "8.00 GB",
                        "start": "2048",
                        "uuid": "f8be84fd-5f1b-4666-ad0d-3cabfdcae49d"
                    }
                },
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "16777216",
                "sectorsize": "512",
                "size": "8.00 GB",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            }
        },
        "discovered_interpreter_python": "/usr/bin/python3",
        "distribution": "Ubuntu",
        "distribution_file_parsed": true,
        "distribution_file_path": "/etc/os-release",
        "distribution_file_variety": "Debian",
        "distribution_major_version": "20",
        "distribution_release": "focal",
        "distribution_version": "20.04",
        "dns": {
            "nameservers": [
                "127.0.0.53"
            ],
            "options": {
                "edns0": true,
                "trust-ad": true
            },
            "search": [
                "ap-northeast-2.compute.internal"
            ]
        },
        "domain": "ap-northeast-2.compute.internal",
        "effective_group_id": 0,
        "effective_user_id": 0,
        "env": {
            "HOME": "/root",
            "LANG": "C.UTF-8",
            "LOGNAME": "root",
            "MAIL": "/var/mail/root",
            "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin",
            "PWD": "/home/ubuntu",
            "SHELL": "/bin/bash",
            "SUDO_COMMAND": "/bin/sh -c echo BECOME-SUCCESS-xrxdryzoctrmelbiiwcsjokehyrlquaz ; /usr/bin/python3 /home/ubuntu/.ansible/tmp/ansible-tmp-1648352758.6667154-1826212-79002759173567/AnsiballZ_setup.py",
            "SUDO_GID": "1000",
            "SUDO_UID": "1000",
            "SUDO_USER": "ubuntu",
            "TERM": "xterm",
            "USER": "root"
        },
        "eth0": {
            "active": true,
            "device": "eth0",
            "features": {
                "esp_hw_offload": "off [fixed]",
                "esp_tx_csum_hw_offload": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "off [fixed]",
                "hsr_dup_offload": "off [fixed]",
                "hsr_fwd_offload": "off [fixed]",
                "hsr_tag_ins_offload": "off [fixed]",
                "hsr_tag_rm_offload": "off [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "off [fixed]",
                "macsec_hw_offload": "off [fixed]",
                "netns_local": "off [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off [fixed]",
                "rx_checksumming": "on [fixed]",
                "rx_fcs": "off [fixed]",
                "rx_gro_hw": "off [fixed]",
                "rx_gro_list": "off",
                "rx_udp_gro_forwarding": "off",
                "rx_udp_tunnel_port_offload": "off [fixed]",
                "rx_vlan_filter": "off [fixed]",
                "rx_vlan_offload": "off [fixed]",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tls_hw_record": "off [fixed]",
                "tls_hw_rx_offload": "off [fixed]",
                "tls_hw_tx_offload": "off [fixed]",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "off [fixed]",
                "tx_checksum_ipv4": "on [fixed]",
                "tx_checksum_ipv6": "on",
                "tx_checksum_sctp": "off [fixed]",
                "tx_checksumming": "on",
                "tx_esp_segmentation": "off [fixed]",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_list": "off [fixed]",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "on [fixed]",
                "tx_ipxip4_segmentation": "off [fixed]",
                "tx_ipxip6_segmentation": "off [fixed]",
                "tx_lockless": "off [fixed]",
                "tx_nocache_copy": "off",
                "tx_scatter_gather": "on",
                "tx_scatter_gather_fraglist": "off [fixed]",
                "tx_sctp_segmentation": "off [fixed]",
                "tx_tcp6_segmentation": "on",
                "tx_tcp_ecn_segmentation": "off [fixed]",
                "tx_tcp_mangleid_segmentation": "off",
                "tx_tcp_segmentation": "on",
                "tx_tunnel_remcsum_segmentation": "off [fixed]",
                "tx_udp_segmentation": "off [fixed]",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "off [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "vlan_challenged": "off [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "10.222.0.95",
                "broadcast": "10.222.0.255",
                "netmask": "255.255.255.0",
                "network": "10.222.0.0"
            },
            "ipv6": [
                {
                    "address": "fe80::44:59ff:feb9:cd0e",
                    "prefix": "64",
                    "scope": "link"
                }
            ],
            "macaddress": "02:44:59:b9:cd:0e",
            "module": "xen_netfront",
            "mtu": 9001,
            "pciid": "vif-0",
            "promisc": false,
            "timestamping": [
                "tx_software",
                "rx_software",
                "software"
            ],
            "type": "ether"
        },
        "fibre_channel_wwn": [],
        "fips": false,
        "form_factor": "Other",
        "fqdn": "ip-10-222-0-95.ap-northeast-2.compute.internal",
        "gather_subset": [
            "all"
        ],
        "hostname": "ip-10-222-0-95",
        "hostnqn": "",
        "interfaces": [
            "eth0",
            "lo"
        ],
        "is_chroot": false,
        "iscsi_iqn": "",
        "kernel": "5.13.0-1019-aws",
        "kernel_version": "#21~20.04.1-Ubuntu SMP Wed Mar 16 11:54:08 UTC 2022",
        "lo": {
            "active": true,
            "device": "lo",
            "features": {
                "esp_hw_offload": "off [fixed]",
                "esp_tx_csum_hw_offload": "off [fixed]",
                "fcoe_mtu": "off [fixed]",
                "generic_receive_offload": "on",
                "generic_segmentation_offload": "on",
                "highdma": "on [fixed]",
                "hsr_dup_offload": "off [fixed]",
                "hsr_fwd_offload": "off [fixed]",
                "hsr_tag_ins_offload": "off [fixed]",
                "hsr_tag_rm_offload": "off [fixed]",
                "hw_tc_offload": "off [fixed]",
                "l2_fwd_offload": "off [fixed]",
                "large_receive_offload": "off [fixed]",
                "loopback": "on [fixed]",
                "macsec_hw_offload": "off [fixed]",
                "netns_local": "on [fixed]",
                "ntuple_filters": "off [fixed]",
                "receive_hashing": "off [fixed]",
                "rx_all": "off [fixed]",
                "rx_checksumming": "on [fixed]",
                "rx_fcs": "off [fixed]",
                "rx_gro_hw": "off [fixed]",
                "rx_gro_list": "off",
                "rx_udp_gro_forwarding": "off",
                "rx_udp_tunnel_port_offload": "off [fixed]",
                "rx_vlan_filter": "off [fixed]",
                "rx_vlan_offload": "off [fixed]",
                "rx_vlan_stag_filter": "off [fixed]",
                "rx_vlan_stag_hw_parse": "off [fixed]",
                "scatter_gather": "on",
                "tcp_segmentation_offload": "on",
                "tls_hw_record": "off [fixed]",
                "tls_hw_rx_offload": "off [fixed]",
                "tls_hw_tx_offload": "off [fixed]",
                "tx_checksum_fcoe_crc": "off [fixed]",
                "tx_checksum_ip_generic": "on [fixed]",
                "tx_checksum_ipv4": "off [fixed]",
                "tx_checksum_ipv6": "off [fixed]",
                "tx_checksum_sctp": "on [fixed]",
                "tx_checksumming": "on",
                "tx_esp_segmentation": "off [fixed]",
                "tx_fcoe_segmentation": "off [fixed]",
                "tx_gre_csum_segmentation": "off [fixed]",
                "tx_gre_segmentation": "off [fixed]",
                "tx_gso_list": "on",
                "tx_gso_partial": "off [fixed]",
                "tx_gso_robust": "off [fixed]",
                "tx_ipxip4_segmentation": "off [fixed]",
                "tx_ipxip6_segmentation": "off [fixed]",
                "tx_lockless": "on [fixed]",
                "tx_nocache_copy": "off [fixed]",
                "tx_scatter_gather": "on [fixed]",
                "tx_scatter_gather_fraglist": "on [fixed]",
                "tx_sctp_segmentation": "on",
                "tx_tcp6_segmentation": "on",
                "tx_tcp_ecn_segmentation": "on",
                "tx_tcp_mangleid_segmentation": "on",
                "tx_tcp_segmentation": "on",
                "tx_tunnel_remcsum_segmentation": "off [fixed]",
                "tx_udp_segmentation": "on",
                "tx_udp_tnl_csum_segmentation": "off [fixed]",
                "tx_udp_tnl_segmentation": "off [fixed]",
                "tx_vlan_offload": "off [fixed]",
                "tx_vlan_stag_hw_insert": "off [fixed]",
                "vlan_challenged": "on [fixed]"
            },
            "hw_timestamp_filters": [],
            "ipv4": {
                "address": "127.0.0.1",
                "broadcast": "",
                "netmask": "255.0.0.0",
                "network": "127.0.0.0"
            },
            "ipv6": [
                {
                    "address": "::1",
                    "prefix": "128",
                    "scope": "host"
                }
            ],
            "mtu": 65536,
            "promisc": false,
            "timestamping": [
                "tx_software",
                "rx_software",
                "software"
            ],
            "type": "loopback"
        },
        "lsb": {
            "codename": "focal",
            "description": "Ubuntu 20.04.4 LTS",
            "id": "Ubuntu",
            "major_release": "20",
            "release": "20.04"
        },
        "lvm": {
            "lvs": {},
            "pvs": {},
            "vgs": {}
        },
        "machine": "x86_64",
        "machine_id": "1087c6e612954fe9bb4b65b33cd01ea6",
        "memfree_mb": 210,
        "memory_mb": {
            "nocache": {
                "free": 767,
                "used": 200
            },
            "real": {
                "free": 210,
                "total": 967,
                "used": 757
            },
            "swap": {
                "cached": 0,
                "free": 0,
                "total": 0,
                "used": 0
            }
        },
        "memtotal_mb": 967,
        "module_setup": true,
        "mounts": [
            {
                "block_available": 1594292,
                "block_size": 4096,
                "block_total": 2016361,
                "block_used": 422069,
                "device": "/dev/root",
                "fstype": "ext4",
                "inode_available": 953863,
                "inode_total": 1024000,
                "inode_used": 70137,
                "mount": "/",
                "options": "rw,relatime,discard",
                "size_available": 6530220032,
                "size_total": 8259014656,
                "uuid": "f8be84fd-5f1b-4666-ad0d-3cabfdcae49d"
            },
            {
                "block_available": 0,
                "block_size": 131072,
                "block_total": 214,
                "block_used": 214,
                "device": "/dev/loop0",
                "fstype": "squashfs",
                "inode_available": 0,
                "inode_total": 16,
                "inode_used": 16,
                "mount": "/snap/amazon-ssm-agent/5163",
                "options": "ro,nodev,relatime",
                "size_available": 0,
                "size_total": 28049408,
                "uuid": "N/A"
            },
            {
                "block_available": 0,
                "block_size": 131072,
                "block_total": 496,
                "block_used": 496,
                "device": "/dev/loop2",
                "fstype": "squashfs",
                "inode_available": 0,
                "inode_total": 11777,
                "inode_used": 11777,
                "mount": "/snap/core20/1376",
                "options": "ro,nodev,relatime",
                "size_available": 0,
                "size_total": 65011712,
                "uuid": "N/A"
            },
            {
                "block_available": 0,
                "block_size": 131072,
                "block_total": 350,
                "block_used": 350,
                "device": "/dev/loop4",
                "fstype": "squashfs",
                "inode_available": 0,
                "inode_total": 482,
                "inode_used": 482,
                "mount": "/snap/snapd/15177",
                "options": "ro,nodev,relatime",
                "size_available": 0,
                "size_total": 45875200,
                "uuid": "N/A"
            },
            {
                "block_available": 0,
                "block_size": 131072,
                "block_total": 445,
                "block_used": 445,
                "device": "/dev/loop1",
                "fstype": "squashfs",
                "inode_available": 0,
                "inode_total": 10849,
                "inode_used": 10849,
                "mount": "/snap/core18/2344",
                "options": "ro,nodev,relatime",
                "size_available": 0,
                "size_total": 58327040,
                "uuid": "N/A"
            },
            {
                "block_available": 0,
                "block_size": 131072,
                "block_total": 544,
                "block_used": 544,
                "device": "/dev/loop3",
                "fstype": "squashfs",
                "inode_available": 0,
                "inode_total": 799,
                "inode_used": 799,
                "mount": "/snap/lxd/22526",
                "options": "ro,nodev,relatime",
                "size_available": 0,
                "size_total": 71303168,
                "uuid": "N/A"
            }
        ],
        "nodename": "ip-10-222-0-95",
        "os_family": "Debian",
        "pkg_mgr": "apt",
        "proc_cmdline": {
            "BOOT_IMAGE": "/boot/vmlinuz-5.13.0-1019-aws",
            "console": [
                "tty1",
                "ttyS0"
            ],
            "nvme_core.io_timeout": "4294967295",
            "panic": "-1",
            "ro": true,
            "root": "PARTUUID=0f6f1620-01"
        },
        "processor": [
            "0",
            "GenuineIntel",
            "Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz"
        ],
        "processor_cores": 1,
        "processor_count": 1,
        "processor_nproc": 1,
        "processor_threads_per_core": 1,
        "processor_vcpus": 1,
        "product_name": "HVM domU",
        "product_serial": "ec2c4fb1-536a-686a-b8bb-8f9527474071",
        "product_uuid": "ec2c4fb1-536a-686a-b8bb-8f9527474071",
        "product_version": "4.11.amazon",
        "python": {
            "executable": "/usr/bin/python3",
            "has_sslcontext": true,
            "type": "cpython",
            "version": {
                "major": 3,
                "micro": 10,
                "minor": 8,
                "releaselevel": "final",
                "serial": 0
            },
            "version_info": [
                3,
                8,
                10,
                "final",
                0
            ]
        },
        "python_version": "3.8.10",
        "real_group_id": 0,
        "real_user_id": 0,
        "selinux": {
            "status": "disabled"
        },
        "selinux_python_present": true,
        "service_mgr": "systemd",
        "ssh_host_key_dsa_public": "AAAAB3NzaC1kc3MAAACBAMHe5u03eoskYRG2oyqNZzBzv11PvpbU2jDJo7R5tGdmw3XQ1y8VYsTXHp8rP09j4KUbFlCgRIK/V1B89Rgf6vQKolhzfhFpfb0rfIJNg9enhyr462ijd+XFo60pPlFu2tEMOZA4MpMGhaVTUnNhF1aCx1GQRXCNcDsckpxyIXE9AAAAFQCatn4OtUb4dDo68Cwk2gh5LrSVJwAAAIBjMSTgNuh+RAkMGLzV/DF8b/9aA6yPmuuqZ+9gV3iYAgonsJSn7jc/LWPSfrw1Ng8f7l4BQcqu38KsopbAts85xfYWbjATSOhfN4nnIWAxwkTwsbOrTEu9QotFCFplE1DRnLZTAZheuvSqNDRVa4QG+pFrYsksRSTyq+Acf933ZwAAAIAz/DNcxB0/O8X8KHmhqqpLf9KAKH/5gVCXojG3qqmusfTeJfmh4Pcr4YiX2aTZdxpOcH5mTWB3+t/1zM+B9oAe3GvScM4MIv//drpFebNpZfOzPSrznT8FOZqMOsxis83SgJJFznQaOesUN5V1TANzhLeDPFZo11sC6E08/bD17g==",
        "ssh_host_key_dsa_public_keytype": "ssh-dss",
        "ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBODUzxHu5CqeOjt1ibZgo6C7sKBzpPk/asCd4Y06pIlpWwugSwlrhITBypFdfCg1LXZRelcXKrpWKZKuJiyBo8Q=",
        "ssh_host_key_ecdsa_public_keytype": "ecdsa-sha2-nistp256",
        "ssh_host_key_ed25519_public": "AAAAC3NzaC1lZDI1NTE5AAAAIC6n7jdI924aPVFLVCKTt31FYsYGYapTvp6+RcaOo27P",
        "ssh_host_key_ed25519_public_keytype": "ssh-ed25519",
        "ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABgQDl+ycswFtMMxRWc+T5CPuokcSak+0GMINyG5/B8AEgdpdVnF0PllotxJnyRXbj9IFFeIcdso7jst39+yiprxSarRnCktVG3YphgG0Pbz1LLtytz0iVDPAWsYvy/Jc8pQDN+ssGarFjwZ04JiSSRivY5j90lHhWBoktoO7yj3pVMWBVvnbfK+6Wk9rZLXexRJ27nWodiEPKFu1uxsU6PWYb/alR6Qg6ju+Hmy/ezZMmvjRn0eJxAyis8XRensRCMfvcUO47wiqj+09w9WitegU0JCLIoSG/2qjIBfK6dSnHMQH059vqlw+Zub4EWrVWCWhBF5z0xMGkxnn4O2r5qq4OTodu0A97+C24vx0Gb+TOxxgQoDteM3D454vu19kdB2A+PIr4xSZpg/gxnhsBWfDqsE0v/iSpguscpt/35WzxKKQChC8jHNtd7HBZPgw47ZjJXBOre2lYGfGHfNAYuxX4U7lsbolXMbParJ49JOBoiu9RS1aMKiGpPHSmCDh+v3s=",
        "ssh_host_key_rsa_public_keytype": "ssh-rsa",
        "swapfree_mb": 0,
        "swaptotal_mb": 0,
        "system": "Linux",
        "system_capabilities": [],
        "system_capabilities_enforced": "False",
        "system_vendor": "Xen",
        "uptime_seconds": 4216,
        "user_dir": "/root",
        "user_gecos": "root",
        "user_gid": 0,
        "user_id": "root",
        "user_shell": "/bin/bash",
        "user_uid": 0,
        "userspace_architecture": "x86_64",
        "userspace_bits": "64",
        "virtualization_role": "guest",
        "virtualization_tech_guest": [
            "xen"
        ],
        "virtualization_tech_host": [],
        "virtualization_type": "xen"
    }
}
```

## 애드혹 명령어를 통해 상세를 파일로 저장하기

```
ansible <그룹명> -i <인벤토리명> -m setup >> ansible_facts.txt
```

