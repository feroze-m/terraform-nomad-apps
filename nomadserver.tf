resource "hcloud_server" "nomadserver" {
  name = format("nomadserver%02d", count.index + 1)
  count = var.nomadserver_count
  server_type = var.nomadserver_type
  image = var.baseimage_name
  location = var.location_name
  firewall_ids = [hcloud_firewall.nomadserver_fw.id, hcloud_firewall.default.id]
  ssh_keys = [ "proxima-sshkey" ]
  placement_group_id = hcloud_placement_group.pg-1.id

  network {
    network_id = hcloud_network.network.id
    ip         = "${lookup(var.nomadserver_ips, count.index, "")}"
  }
  depends_on = [
    hcloud_network_subnet.proxima_subnet
  ]
  user_data = templatefile("${path.module}/userdata/nomadserver.tmpl",{
    private_IP = "${lookup(var.nomadserver_ips, count.index, "")}"
    consul01_IP = "${lookup(var.consulserver_ips, 0, "")}"
    consul02_IP = "${lookup(var.consulserver_ips, 1, "")}"
    consul03_IP = "${lookup(var.consulserver_ips, 2, "")}"
  })
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

variable "nomadserver_type" {
  type  = string
  default = "cx11"
}

variable "nomadserver_count" {
  type = string
  default = 0
}

variable "nomadserver_ips" {
  type = map(string)
  default = {}
}