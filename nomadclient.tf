resource "hcloud_server" "nomadclient" {
  name = format("nomadclient%02d", count.index +1)
  count = var.nomadclient_count
  server_type = var.nomadclient_type
  image = var.baseimage_name
  location = var.location_name
  firewall_ids = [hcloud_firewall.default.id]
  ssh_keys = [ "proxima-sshkey" ]
  placement_group_id = hcloud_placement_group.pg_nomad.id

  network {
    network_id = hcloud_network.network.id
    ip         = "${lookup(var.nomadclient_ips, count.index, "")}"
  }
  depends_on = [
    hcloud_network_subnet.proxima_subnet
  ]
  user_data = templatefile("${path.module}/userdata/nomadclient.tmpl",{
    private_IP = "${lookup(var.nomadclient_ips, count.index, "")}"
    consul01_IP = "${lookup(var.consulserver_ips, 0, "")}"
    consul02_IP = "${lookup(var.consulserver_ips, 1, "")}"
    consul03_IP = "${lookup(var.consulserver_ips, 2, "")}"
    nomadserver01_IP = "${lookup(var.nomadserver_ips, 0, "")}"
    nomadserver02_IP = "${lookup(var.nomadserver_ips, 1, "")}"
    nomadserver03_IP = "${lookup(var.nomadserver_ips, 2, "")}"
  })
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
  default = 20
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

variable "nomadclient_ips" {
  type = map(string)
  default = {}
}