# terraform-hetzner
Terraform code to deploy resources in hertzner cloud

# What it does
1. Deploys VMs for bastion, gh-runner, consul, nomad cluster with terraform
2. Stores the tfstate in s3 or terraform cloud
3. Bastion/Jump host for ssh access. We can add other binaries like nomad (or terraform) if needed for live env troubleshooting.
4. Github Runner for deploying nomad jobs
5. Configures consul servers (3 VMs)
6. Configures nomad servers (3 VMs)
7. Configures nomad clients (`N` clients)

# How: (Add details as we go)
1. Clone this repo to your local machine
2. Log into the Hetzner account. Generate an api token with name terraform-<project-name>
    - Rename the `secrets_tmpl.tfvars` to `envs/$project-secrets.tfvars`
    - Update the token locally in `$project-secrets.tfvars` (will try to make this work at run time using s3 url or terraform cloud)
3. Create an ssh-keypair and copy the .pem and .prub files to the root dir -- `infra/`
4. Update the var `ssh-key-name` in `envs/proxima.tfvars` to specify your filename without extension
5. Run terraform init, plan and apply (e.g for proxima below)
    - `terraform init`
    - `terraform plan --var-file=envs/proxima.tfvars --var-file=envs/proxima-secrets.tfvars`
    - `terraform apply --var-file=envs/proxima.tfvars --var-file=envs/proxima-secrets.tfvars`
6. Terraform output will give the IP addresses of each VM
7. Consul service web UI is accessible at `http://<consulserver_IP>:8500`
8. Nomad service web UI is accessible at `http://<nomadserver_IP>:4646`

#Important:
1. Defaults will deploy 0 servers, so make sure to have the count updated.
	- 0 Bastion VM
	- 0 Github runner
	- 0 Consul Servers
	- 0 Nomad Servers
	- 0 Nomad Client
2. If you wish to increase the count of any of the servers, edit the envs/proxima.tfvars accordingly. 
3. Datacenter and image may also be changed as needed.
4. To deploy this infrastructure for an entirely new project - say `sirius`
	- Create `envs/sirius.tfvars` and `envs/sirius-secrets.tfvars` similar to proxima.tfvars
	- Provide the count and IP addresses of servers to be created
	- Run terraform commands
5. In the userdata section, ideally you wouldn't need to edit any values, except for 
	- Github runner token, which is going to be specific to the repo for nomad jobs
	- If consulserver/nomadserver count is increased to more than 3 (again not really needed), 
		- Update all the files in `userdata/$servertype.tmpl`, to include the reference to new servers.

X. `Improvements:`
    - `Apply domain names using hcloud_rdns`
    - `Add ssl certs for https`
    - `Possible addition later: Atlantis webhook to deploy these with github PRs. Needs an atlantis host with internet/public access.`

# Infrastructure Diagram

![infra_diag](https://user-images.githubusercontent.com/103216595/162854278-85b2de02-5f83-446a-b98b-6cceade8ce13.png)


#Hetzner Cloud has an api, which can be very helpful while working with cli and terraform. Notes below:

* Repo: https://github.com/hetznercloud/cli
* export HCLOUD_TOKEN=xxxxtokenxxxx and cli is ready to use

`ferozem@Ferozes-MacBook-Air terraform-hetzner % hcloud datacenter list`  
`ID   NAME        DESCRIPTION          LOCATION`  
`2    nbg1-dc3    Nuremberg 1 DC 3     nbg1`  
`3    hel1-dc2    Helsinki 1 DC 2      hel1`  
`4    fsn1-dc14   Falkenstein 1 DC14   fsn1`  
`5    ash-dc1     Ashburn DC1          ash`  

