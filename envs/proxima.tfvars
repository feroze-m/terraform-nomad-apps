
location_name = "nbg1"
baseimage_name = "debian-10"
domain_name = "proxima-myapp.com"
prvt_domain_name = "proxima-myapp1.com"

bastion_count = 1
consulserver_count = 3
nomadserver_count = 3
nomadclient_count = 1

consulserver_ips = {
    "0" = "10.0.1.11"
    "1" = "10.0.1.12"
    "2" = "10.0.1.13"
    }
nomadserver_ips = {
    "0" = "10.0.1.21"
    "1" = "10.0.1.22"
    "2" = "10.0.1.23"
    }
nomadclient_ips = {
    "0" = "10.0.1.31"
    "1" = "10.0.1.32"
    "2" = "10.0.1.33"
    }
bastion_ips = {
    "0" = "10.0.1.99"
    }