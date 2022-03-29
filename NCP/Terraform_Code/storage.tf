resource "ncloud_block_storage" "storage" {
  for_each = {
    for server in ncloud_server.server :
    server.name => server
  }

  server_instance_no = each.value.id
  name               = format("%s-disk", each.key)
  size               = "10"
  description        = "terraform test"
  disk_detail_type   = "SSD"
}
