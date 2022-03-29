# VPC 생성하기
resource "ncloud_vpc" "test" {
  name = "test"
  ipv4_cidr_block = "192.168.0.0/16"
}

# Subnet 생성하기
resource "ncloud_subnet" "test" {
    vpc_no             = ncloud_vpc.test.id
    subnet             = cidrsubnet(ncloud_vpc.test.ipv4_cidr_block, 8, 1)
    zone               = "KR-1"
    network_acl_no     = ncloud_vpc.test.default_network_acl_no
    subnet_type        = "PUBLIC"
    usage_type         = "GEN"
}

