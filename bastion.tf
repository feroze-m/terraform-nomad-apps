resource "hcloud_server" "bastion" {
  name = "bastion01"
  server_type = "cx11"
  image = data.hcloud_image.image_debian10.id
  datacenter = data.hcloud_datacenters.ds_euro1

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
