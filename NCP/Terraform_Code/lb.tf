resource "ncloud_lb" "test" {
  type           = "APPLICATION"
  name           = "tf-lb-test"
  network_type   = "PUBLIC"
  subnet_no_list = [ncloud_subnet.lb_test.id]
}

resource "ncloud_lb_listener" "test" {
  load_balancer_no = ncloud_lb.test.id
  protocol         = var.lb_info.target-1.protocol
  port             = var.lb_info.target-1.port
  target_group_no  = ncloud_lb_target_group.test.id
}
