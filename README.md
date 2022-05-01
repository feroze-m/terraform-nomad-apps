# terraform-hetzner
Terraform code to deploy resources in hertzner cloud

# What it does
1. Deploys VMs for bastion, consul, nomad cluster with terraform
2. Stores the tfstate in s3 or terraform cloud
3. Bastion/Jump host for ssh access. We can add other binaries like nomad (or terraform) if needed for live env troubleshooting.
4. Configures consul servers (3 VMs)
5. Configures nomad servers (3 VMs)
6. Configures nomad clients (`N` clients)

# How: (Add details as we go)
1. Clone this repo to your local machine
2. Log into the Hetzner account. Generate an api token with name terraform-<project-name>
    - Rename the `secrets_tmpl.tfvars` to `secrets.tfvars`
    - Update the token locally in `secrets.tfvars` (will try to make this work at run time using s3 url or terraform cloud)
3. Run terraform init, plan and apply
    - `terraform init`
    - `terraform plan --var-file=envs/proxima.tfvars --var-file=envs/secrets.tfvars`
    - `terraform apply --var-file=envs/proxima.tfvars --var-file=envs/secrets.tfvars`
4. Terraform output will give the IP addresses of each VM
5. Consul service web UI is accessible at `http://<consulserver_IP>:8500`
6. Nomad service web UI is accessible at `http://<nomadserver_IP>:4646`

7. `Improvements:`
    - `Apply domain names using hcloud_rdns`
    - `Add ssl certs for https`
    - `Possible addition later: Atlantis webhook to deploy these with github PRs. Needs an atlantis host with internet/public access.`

# Infrastructure Diagram

![infra_diag](https://user-images.githubusercontent.com/103216595/162854278-85b2de02-5f83-446a-b98b-6cceade8ce13.png)


#Hetzner Cloud has an api, which can be very helpful while working with cli and terraform. Notes below:

* Repo: https://github.com/hetznercloud/cli
* export HCLOUD_TOKEN=xxxxtokenxxxx and cli is ready to use

`ferozem@Ferozes-MacBook-Air terraform-hetzner % hcloud datacenter list
ID   NAME        DESCRIPTION          LOCATION
2    nbg1-dc3    Nuremberg 1 DC 3     nbg1
3    hel1-dc2    Helsinki 1 DC 2      hel1
4    fsn1-dc14   Falkenstein 1 DC14   fsn1
5    ash-dc1     Ashburn DC1          ash
`

