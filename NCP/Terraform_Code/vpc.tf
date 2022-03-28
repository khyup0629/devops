resource "ncloud_vpc" "test" {
  name = "test"
  ipv4_cidr_block = "192.168.0.0/16"
}

resource "ncloud_subnet" "test" {
    vpc_no             = ncloud_vpc.test.id
    subnet             = cidrsubnet(ncloud_vpc.test.ipv4_cidr_block, 8, 1)
    zone               = "KR-1"
    network_acl_no     = ncloud_vpc.test.default_network_acl_no
    subnet_type        = "PUBLIC"
    usage_type         = "GEN"
}

locals {
  network_interface_private_ip = {
    tf-test-1 = "192.168.1.1",
    tf-test-2 = "192.168.1.2",
  }
}

resource "ncloud_network_interface" "nic" {
  for_each = local.network_interface_private_ip
  name = each.key
  description = "terraform test"
  subnet_no = ncloud_subnet.test.id
  private_ip = each.value
  access_control_groups = [ncloud_access_control_group.acg.id]
}
