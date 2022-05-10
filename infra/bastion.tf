resource "hcloud_server" "bastion" {
  name = format("bastion%02d", count.index + 1)
  count = var.bastion_count
  server_type = var.bastion_server_type
  image = var.baseimage_name
  location = var.location_name
  firewall_ids = [hcloud_firewall.bastion_fw.id]
  ssh_keys = [ "proxima-sshkey" ]

  network {
    network_id = hcloud_network.network.id
    ip         = "${lookup(var.bastion_ips, count.index, "")}"
  }
  depends_on = [
    hcloud_network_subnet.proxima_subnet
  ]
  user_data = templatefile("${path.module}/userdata/bastion.tmpl",{
    private_IP = "${lookup(var.bastion_ips, count.index, "")}"
    consul01_IP = "${lookup(var.consulserver_ips, 0, "")}"
    consul02_IP = "${lookup(var.consulserver_ips, 1, "")}"
    consul03_IP = "${lookup(var.consulserver_ips, 2, "")}"
  })
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

variable "bastion_ips" {
  type = map(string)
  default = {}
}