variable "network_name" {
  type = string
  default = "proxima_network"
}
variable "hcloud_network" {
  type = string
  default = "proxima_network"
  description = "Default Network"
}
variable "hcloud_network_subnet" {
  type = string
  default = "proxima_subnet"
  description = "Default Subnet"
}

variable "hcloud_datacenters" {
  type = string
  default = "nbg1-dc3"
  description = "Default Datacenter"
}

variable "hcloud_image" {
  type = string
  default = "debian-10"
}