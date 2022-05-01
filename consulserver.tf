resource "hcloud_server" "consulserver" {
  name = format("consulserver%02d", count.index + 1)
  count = var.consulserver_count
  server_type = var.consulserver_type
  image = var.baseimage_name
  location = var.location_name
  firewall_ids = [hcloud_firewall.consul_8500_tcp.id, hcloud_firewall.consul_8500_udp.id, hcloud_firewall.default.id]
  ssh_keys = [ "proxima-sshkey" ]
  placement_group_id = hcloud_placement_group.pg_consul.id

  network {
    network_id = hcloud_network.network.id
    ip         = "${lookup(var.consulserver_ips, count.index, "")}"
/*    ip         = "10.0.1.211"
    alias_ips  = [
      "10.0.1.111"
    ]
    */
  }
  depends_on = [
    hcloud_network_subnet.proxima_subnet
  ]
  user_data = templatefile("${path.module}/userdata/consul.tmpl",{
    private_IP = "${lookup(var.consulserver_ips, count.index, "")}"
    consul01_IP = "${lookup(var.consulserver_ips, 0, "")}"
    consul02_IP = "${lookup(var.consulserver_ips, 1, "")}"
    consul03_IP = "${lookup(var.consulserver_ips, 2, "")}"
  })
}

resource "hcloud_firewall" "consul_8500_tcp" {
  name = "consul-8500-tcp"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "8500"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}
resource "hcloud_firewall" "consul_8500_udp" {
  name = "consul-8500-udp"
  rule {
    direction = "in"
    protocol  = "udp"
    port      = "8500"
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

variable "consulserver_ips" {
  type = map(string)
  default = {}
}