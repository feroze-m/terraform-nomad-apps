# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "Terraform"
  public_key = file("~/.ssh/id_rsa.pub")
}

#To `spread` the VMs on separate physical servers
resource "hcloud_placement_group" "placement-group-1" {
  name = "placement-group-1"
  type = "spread"
  labels = {
    key = "proxima"
  }
}

resource "hcloud_network" "network" {
  name     = var.hcloud_network
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "subnet" {
  type         = "cloud"
  name         = var.hcloud_network_subnet
  network_id   = hcloud_network.network.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

