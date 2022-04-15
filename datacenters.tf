data "hcloud_datacenters" "ds_euro1" {
    name = nbg1-dc3
    description = Nuremberg 1 DC3
}

data "hcloud_datacenters" "ds_euro2" {
    name = hel1-dc2 
    description = Helsinki 1 DC2
}

data "hcloud_datacenters" "ds_euro3" {
    name = fsn1-dc14
    description = Falkenstein 1 DC14
}

data "hcloud_datacenters" "ds_us1" {
    name = ash-dc1
    description = Ashburn DC1
}
