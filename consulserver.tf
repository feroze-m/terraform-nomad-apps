resource "hcloud_server" "consulserver" {
  name = format("consulserver%02d", count.index + 1)
  count = var.consulserver_count
  server_type = var.consulserver_type
  image = var.baseimage_name
  location = var.location_name
  firewall_ids = [hcloud_firewall.consul_fw.id, hcloud_firewall.default.id]
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

resource "hcloud_rdns" "consulserver" {
  count = var.consulserver_count
  server_id  = hcloud_server.consulserver[count.index].id
  ip_address = hcloud_server.consulserver[count.index].ipv4_address
  dns_ptr    = "${hcloud_server.consulserver[count.index].name}.example.com"
}

resource "hcloud_firewall" "consul_fw" {
  name = "consul-firewall"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "8500-8502"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

variable "consulserver_type" {
  type  = string
  default = "cx11"
}

variable "consulserver_count" {
  type = string
  default = 0
}