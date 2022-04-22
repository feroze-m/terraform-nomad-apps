resource "hcloud_server" "nomadserver" {
  name = format("nomadserver%02d", count.index + 1)
  count = var.nomadserver_count
  server_type = var.nomadserver_type
  image = var.baseimage_name
  location = var.location_name
  firewall_ids = [hcloud_firewall.nomadserver_fw.id, hcloud_firewall.default.id]
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

resource "hcloud_firewall" "nomadserver_fw" {
  name = "nomadserver-firewall"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "4646"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_rdns" "nomadserver" {
  count = var.nomadserver_count
  server_id  = hcloud_server.nomadserver[count.index].id
  ip_address = hcloud_server.nomadserver[count.index].ipv4_address
  dns_ptr    = "${hcloud_server.nomadserver[count.index].name}.example.com"
}

variable "nomadserver_type" {
  type  = string
  default = "cx11"
}

variable "nomadserver_count" {
  type = string
  default = 0
}