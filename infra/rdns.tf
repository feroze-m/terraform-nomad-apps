resource "hcloud_rdns" "bastion" {
  count = var.bastion_count
  server_id  = hcloud_server.bastion[count.index].id
  ip_address = hcloud_server.bastion[count.index].ipv4_address
  dns_ptr    = "${hcloud_server.bastion[count.index].name}.${var.domain_name}"
}


resource "hcloud_rdns" "consulserver" {
  count = var.consulserver_count
  server_id  = hcloud_server.consulserver[count.index].id
  ip_address = hcloud_server.consulserver[count.index].ipv4_address
  dns_ptr    = "${hcloud_server.consulserver[count.index].name}.${var.domain_name}"
}

resource "hcloud_rdns" "nomadclient" {
  count = var.nomadclient_count
  server_id  = hcloud_server.nomadclient[count.index].id
  ip_address = hcloud_server.nomadclient[count.index].ipv4_address
  dns_ptr    = "${hcloud_server.nomadclient[count.index].name}.${var.domain_name}"
}

resource "hcloud_rdns" "nomadserver" {
  count = var.nomadserver_count
  server_id  = hcloud_server.nomadserver[count.index].id
  ip_address = hcloud_server.nomadserver[count.index].ipv4_address
  dns_ptr    = "${hcloud_server.nomadserver[count.index].name}.${var.domain_name}"
}
