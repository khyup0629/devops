# network interface 생성하기
locals {
  network_interface_private_ip = {
    tf-vm-1 = {
      private_ip = "192.168.1.1",
      index      = 0,
    }
    tf-vm-2 = {
      private_ip = "192.168.2.1",
      index      = 1,
    }
  }
}

resource "ncloud_network_interface" "nic" {
  for_each              = local.network_interface_private_ip
  name                  = each.key
  description           = "terraform test"
  subnet_no             = ncloud_subnet.test[each.value.index].id
  private_ip            = each.value.private_ip
  access_control_groups = [ncloud_access_control_group.acg.id]
}

