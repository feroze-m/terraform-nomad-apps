resource "hcloud_server" "bastion" {
  name = "bastion01"
  count = var.bastion_count
  server_type = var.bastion_server_type
  image = var.baseimage_name
  location = var.location_name
  firewall_ids = [hcloud_firewall.bastion_fw.id]

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

resource "hcloud_rdns" "bastion" {
  count = var.bastion_count
  server_id  = hcloud_server.bastion[count.index].id
  ip_address = hcloud_server.bastion[count.index].ipv4_address
  dns_ptr    = "bastion01.example.com"
}

resource "hcloud_firewall" "bastion_fw" {
  name = "bastion-firewall"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

variable "bastion_server_type" {
  type  = string
  default = "cx11"
}

variable "bastion_count" {
  type = string
  default = 0
}