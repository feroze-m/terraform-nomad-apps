/*resource "hcloud_ssh_key" "default" {
  name       = "Terraform"
  public_key = file("./${var.ssh_key_name}.pub")
}
*/
data "hcloud_image" "baseimage_name" {
  name = var.baseimage_name
}

#To `spread` the VMs on separate physical servers
resource "hcloud_placement_group" "pg-1" {
  name = "pg-1"
  type = "spread"
  labels = {
    key = "proxima"
  }
}

resource "hcloud_network" "network" {
  name     = var.hcloud_network
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "proxima_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.network.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_firewall" "default" {
  name = "default-firewall"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "any"
    source_ips = [hcloud_network_subnet.proxima_subnet.ip_range]
  }
  rule {
    direction = "in"
    protocol  = "udp"
    port      = "any"
    source_ips = [hcloud_network_subnet.proxima_subnet.ip_range]
  }
}
