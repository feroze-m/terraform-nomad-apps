# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

data "hcloud_image" "baseimage_name" {
  name = var.baseimage_name
}

#To `spread` the VMs on separate physical servers
resource "hcloud_placement_group" "pg_bastion" {
  name = "pg_bastion"
  type = "spread"
  labels = {
    key = "proxima"
  }
}
resource "hcloud_placement_group" "pg_consul" {
  name = "pg_consul"
  type = "spread"
  labels = {
    key = "proxima"
  }
}
resource "hcloud_placement_group" "pg_nomad" {
  name = "pg_nomad"
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

