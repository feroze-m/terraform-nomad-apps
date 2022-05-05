resource "hcloud_server" "ghrunner" {
  name = format("ghrunner%02d", count.index +1)
  count = var.ghrunner_count
  server_type = var.ghrunner_type
  image = var.baseimage_name
  location = var.location_name
  firewall_ids = [ hcloud_firewall.default.id ]
  ssh_keys = [ "proxima-sshkey" ]
  provisioner "file" {
    source      = "binary/terraform"
    destination = "/usr/bin/terraform"
  }

  network {
    network_id = hcloud_network.network.id
    ip         = "${lookup(var.ghrunner_ips, count.index, "")}"
  }
  depends_on = [
    hcloud_network_subnet.proxima_subnet
  ]
  user_data = templatefile("${path.module}/userdata/ghrunner.tmpl",{
    private_IP = "${lookup(var.ghrunner_ips, count.index, "")}"
    consul01_IP = "${lookup(var.consulserver_ips, 0, "")}"
    consul02_IP = "${lookup(var.consulserver_ips, 1, "")}"
    consul03_IP = "${lookup(var.consulserver_ips, 2, "")}"
  })
}

variable "ghrunner_type" {
  type  = string
  default = "cx11"
}

variable "ghrunner_count" {
  type = string
  default = 0
}
variable "ghrunner_volume_size" {
  type = string
  default = 10
}
resource "hcloud_volume" "ghrunner" {
  count     = var.ghrunner_count
  size      = var.ghrunner_volume_size
  name      = format("ghrunner%02d_data", count.index + 1)
  location  = var.location_name
  delete_protection = true
}

resource "hcloud_volume_attachment" "ghrunner" {
  count     = var.ghrunner_count
  volume_id = hcloud_volume.ghrunner[count.index].id
  server_id = hcloud_server.ghrunner[count.index].id
  automount = true
}

variable "ghrunner_ips" {
  type = map(string)
  default = {}
}
