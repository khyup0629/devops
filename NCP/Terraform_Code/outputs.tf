output "server_image_product_code" {
  value = data.ncloud_server_image.image.id
}

output "server_product_code" {
  value = data.ncloud_server_product.product.id
}

output "server_name_list" {
  value = join(",", ncloud_server.server.*.name)
}
