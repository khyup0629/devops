# network interface 생성하기
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

