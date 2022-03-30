output "server_image_product_code" {
  value = data.ncloud_server_image.image.id
}

output "server_product_code" {
  value = data.ncloud_server_product.product.id
}

output "server_ip" {
  value = [
    for server in ncloud_server.server : {
      public_ip  = server.public_ip
      private_ip = server.private_ip
    }
  ]
}

output "root_password" {
  value     = data.ncloud_root_password.password[*]
  sensitive = true
}

output "lb_ip_list" {
  value = ncloud_lb.test.ip_list
}
