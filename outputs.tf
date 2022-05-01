output "bastion_ips" {
    value = hcloud_server.bastion[*].ipv4_address
}
output "consulserver_ips" {
    value = hcloud_server.consulserver[*].ipv4_address
}
output "nomadserver_ips" {
    value = hcloud_server.nomadserver[*].ipv4_address
}
output "nomadclient_ips" {
    value = hcloud_server.nomadclient[*].ipv4_address
}