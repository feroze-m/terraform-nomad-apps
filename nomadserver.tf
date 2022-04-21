resource "hcloud_server" "bastion" {
  name = format("nomadserver%2d", nomadserver_count)
  count = var.nomadserver_count
  server_type = var.nomadserver_type
  image = var.baseimage_name
  location = var.location_name

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

variable "nomadserver_type" {
  type  = string
  default = "cx11"
}

variable "nomadserver_count" {
  type = string
  default = 0
}