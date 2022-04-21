terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    tls = {
      source = "tls"
    }
  }
  required_version = ">= 0.13"
}