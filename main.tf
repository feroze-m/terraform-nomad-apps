# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

#To `spread` the VMs on separate physical servers
resource "hcloud_placement_group" "placement-group-1" {
  name = "placement-group-1"
  type = "spread"
  labels = {
    key = "proxima"
  }
}

