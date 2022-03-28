# 서버 ssh 키 생성
resource "ncloud_login_key" "loginkey" {
  key_name = "tf-test"
}

# 서버2개 생성
resource "ncloud_server" "server" {
  count                     = 2
  name                      = format("tf-vm-%s", count.index + 1)
  server_image_product_code = data.ncloud_server_image.image.id
  server_product_code       = data.ncloud_server_product.product.id
  login_key_name            = ncloud_login_key.loginkey.key_name
  subnet_no                 = ncloud_subnet.test.id

  network_interface {
    network_interface_no = ncloud_network_interface.nic[format("tf-test-%s", count.index+1)].id
    order = 0
  }
}

# ncloud image & product : https://github.com/NaverCloudPlatform/terraform-ncloud-docs/blob/main/docs/server_image_product.md
# 우분투 이미지 id 가져오기
data "ncloud_server_image" "image" {
  filter {
    name   = "os_information"
    values = ["Ubuntu Server 18.04 (64-bit)"]
  }
}

# 서버 스펙 id 가져오기
data "ncloud_server_product" "product" {
  server_image_product_code = data.ncloud_server_image.image.id

  filter {
    name   = "product_code"
    values = ["SSD"]
    regex  = true
  }

  filter {
    name   = "cpu_count"
    values = ["2"]
  }

  filter {
    name   = "memory_size"
    values = ["8GB"]
  }

  filter {
    name   = "base_block_storage_size"
    values = ["50GB"]
  }

  filter {
    name   = "product_type"
    values = ["STAND"]
  }
}
