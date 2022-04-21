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

variable "datacenter_name" {
  type = list(string)
  default = ["nbg1-dc3"]
  description = "Default to Nuremberg 1 DC3"
}

variable "base_image_name" {
  type = string
  default = "debian-10"
}

variable "lb_count" {
  type    = string
  default = 1
}

variable "hcloud_token" {
  type    = string
  default = proxima_token
}