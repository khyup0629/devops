# 베이그런트 프로비저닝 코드 작성

- [VirtualBox 설치](https://github.com/khyup0629/docker-kubernetes/blob/main/Docker/VirtualBox_and_Vagrant_Installation.md#%EB%B2%84%EC%B6%94%EC%96%BC%EB%B0%95%EC%8A%A4virtualbox-%EC%84%A4%EC%B9%98)
- [Vagrant 설치](https://github.com/khyup0629/docker-kubernetes/blob/main/Docker/VirtualBox_and_Vagrant_Installation.md#%EB%B2%A0%EC%9D%B4%EA%B7%B8%EB%9F%B0%ED%8A%B8vagrant-%EC%84%A4%EC%B9%98)
- [Vagrant 테스트](https://github.com/khyup0629/docker-kubernetes/blob/main/Docker/VirtualBox_and_Vagrant_Installation.md#%EB%B2%A0%EC%9D%B4%EA%B7%B8%EB%9F%B0%ED%8A%B8-%EA%B5%AC%EC%84%B1-%EB%B0%8F-%ED%85%8C%EC%8A%A4%ED%8A%B8)

`vagrant init`으로 `vagrantfile`을 생성하고, 코드 에디터를 이용해 아래처럼 내용을 수정합니다.

``` ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
	config.vm.define "m-k8s" do |cfg|
		cfg.vm.box = "sysnet4admin/CentOS-k8s"
		cfg.vm.provider "virtualbox" do |vb|
			vb.name = "m-k8s(github_SysNet4Admin)"
			vb.cpus = 2
			vb.memory = 2048
			vb.customize ["modifyvm", :id, "--groups", "/k8s-SM(github_SysNet4Admin)"]
		end
		cfg.vm.host_name = "m-k8s"
		cfg.vm.network "private_network", ip: "192.168.1.10"
		cfg.vm.network "forwarded_port", guest: 22, host: 60010, auto_correct: true, id: "ssh"
		cfg.vm.synced_folder "../data", "/vagrant", disabled: true
	end	
end
```   
- 1~2 : 에디터에 현재 파일이 루비(ruby)임을 인식하게 하는 호환 코드.
- 3 : "2"는 베이그런트에서 루비로 코드를 읽어 들여 실행할 때 작동하는 API 버전
- 4 : 생성할 가상머신을 `m-k8s`로 정의합니다. 아래에는 가상 머신에 대한 설정을 정의합니다.
- 5 : 가상 이미지 파일
- 6 : 가상 머신의 provider가 virtualbox임을 정의합니다. 아래에는 virtualbox에서 필요한 설정을 정의합니다.
- 7~11 : virtualbox에 생성한 가상 머신의 이름, CPU수, 메모리 크기, 소속 그룹을 명시합니다.
- 12 : 호스트 이름을 'm-k8s`로 정의.
- 13 : 호스트 전용 네트워크를 private_network로 정의하고 ip 주소를 정의합니다(eth1 인터페이스가 호스트 전용으로 설정됩니다).
- 14 : 게스트 22번 포트를 호스트 60010번 포트로 포워딩 합니다.
- 15 : 호스트와 게스트 사이에 디렉토리 동기화가 이루어지지 않게 설정합니다.

`vagrant up`을 통해 위의 설정으로 가상 머신을 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/151112532-c491f05f-58a5-4fcc-94a6-ec56b8b6c320.png)

`vagrant ssh`로 가상 머신에 접근해 `ip addr show eth1`을 통해 호스트 전용 네트워크가 제대로 설정되었는지 확인합니다.   

## 더 이상 진행할 수 없는 이슈

![image](https://user-images.githubusercontent.com/43658658/151116709-71a75836-6c2a-42a8-aead-dcdfd4269de6.png)   
=> [vagrant 트러블슈팅](https://fellowship.hackbrightacademy.com/materials/resources/vagrant-troubleshooting/)   
현재 컴퓨터의 CPU가 `가상화 기술`을 지원하지 않기 때문에 발생하는 문제입니다.







