resource "ncloud_lb_target_group" "test" {
  name        = "tf-tg-test"
  target_type = "VSVR"
  vpc_no      = ncloud_vpc.test.vpc_no
  protocol    = var.lb_info.target-1.protocol
  port        = var.lb_info.target-1.port
  description = "terraform test"
  health_check {
    protocol       = "HTTP"
    port           = 80
    url_path       = "/"
    http_method    = "GET"
    cycle          = 30
    up_threshold   = 2
    down_threshold = 2
  }
  # RR : Round Robin / SIPHS : Source IP Hash / LC : Least Connetion / MH : Maglev Hash
  # RR | MH : TCP
  # RR | SIPHS | LC : PROXY_TCP, HTTP, HTTPS
  algorithm_type = "RR"
}

resource "ncloud_lb_target_group_attachment" "test" {
  target_group_no = ncloud_lb_target_group.test.id
  target_no_list  = ncloud_server.server.*.id
}
