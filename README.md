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
    * Save the token locally in secrets.tfvars. (will try to make this work at run time using s3 url or terraform cloud)
2. Run terraform init, plan and apply
3. `Possible addition later: Atlantis webhook to deploy these with github PRs. Needs an atlantis host with internet/public access.`

# Infrastructure Diagram

![infra_diag](https://user-images.githubusercontent.com/103216595/162854278-85b2de02-5f83-446a-b98b-6cceade8ce13.png)


