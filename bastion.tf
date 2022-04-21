resource "hcloud_server" "bastion" {
  name = "bastion01"
  count = var.bastion_count
  server_type = var.bastion_server_type
  image = var.baseimage_name
  location = var.location_name

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.1.201"
    alias_ips  = [
      "10.0.1.101"
    ]
  }
  depends_on = [
    hcloud_network_subnet.proxima_subnet
  ]
}  

variable "bastion_server_type" {
  type  = string
  default = "cx11"
}

variable "bastion_count" {
  type = string
  default = 0
}