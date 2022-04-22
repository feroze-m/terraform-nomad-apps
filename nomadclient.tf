resource "hcloud_server" "nomadclient" {
  name = format("nomadclient%02d", count.index +1)
  count = var.nomadclient_count
  server_type = var.nomadclient_type
  image = var.baseimage_name
  location = var.location_name
  firewall_ids = [hcloud_firewall.default.id]
  placement_group_id = hcloud_placement_group.pg-1.id

  network {
    network_id = hcloud_network.network.id
/*    ip         = "10.0.1.211"
    alias_ips  = [
      "10.0.1.111"
    ]
    */
  }
  depends_on = [
    hcloud_network_subnet.proxima_subnet
  ]
}  

resource "hcloud_rdns" "nomadclient" {
  count = var.nomadclient_count
  server_id  = hcloud_server.nomadclient[count.index].id
  ip_address = hcloud_server.nomadclient[count.index].ipv4_address
  dns_ptr    = "${hcloud_server.nomadclient[count.index].name}.example.com"
}

variable "nomadclient_type" {
  type  = string
  default = "cx11"
}

variable "nomadclient_count" {
  type = string
  default = 0
}
variable "nomadclient_volume_size" {
  type = string
  default = 10
}
resource "hcloud_volume" "nomadclient" {
  count     = var.nomadclient_count
  size      = var.nomadclient_volume_size
  name      = format("nomadclient%02d_data", count.index + 1)
  location  = var.location_name
  delete_protection = true
}

resource "hcloud_volume_attachment" "nomadclient" {
  count     = var.nomadclient_count
  volume_id = hcloud_volume.nomadclient[count.index].id
  server_id = hcloud_server.nomadclient[count.index].id
  automount = true
}
