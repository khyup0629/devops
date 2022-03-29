# VPC 생성하기
resource "ncloud_vpc" "test" {
  name            = "test"
  ipv4_cidr_block = "192.168.0.0/16"
}

# Subnet 생성하기
resource "ncloud_subnet" "test" {
  vpc_no         = ncloud_vpc.test.id
  name = "tf-subnet-test"
  subnet         = cidrsubnet(ncloud_vpc.test.ipv4_cidr_block, 8, 1)
  zone           = "KR-1"
  network_acl_no = ncloud_vpc.test.default_network_acl_no
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
}

# lb subnet 생성하기
resource "ncloud_subnet" "lb_test" { 
  vpc_no         = ncloud_vpc.test.id
  name = "tf-lb-subnet-test"
  subnet         = cidrsubnet(ncloud_vpc.test.ipv4_cidr_block, 8, 10)
  zone           = "KR-1"
  network_acl_no = ncloud_vpc.test.default_network_acl_no
  # lb 전용 subnet은 private으로 지정해야 함
  subnet_type    = "PRIVATE"
  usage_type     = "LOADB"
}
