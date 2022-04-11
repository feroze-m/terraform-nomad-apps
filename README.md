# terraform-hertzner
Terraform code to deploy resources in hertzner cloud

# what it does
1. Deploys VMs
2. Configures consul cluster (3 VMs)
3. Configures nomad cluster (3 servers + `N` clients)
4. Stores the tfstate in s3 or terraform cloud

# How: (Add details as we go)
1. Clone the repo to your local machine
2. Run terraform init, plan and apply

# Infrastructure Diagram

![infra_diag](https://user-images.githubusercontent.com/103216595/162817884-d36f5f20-96c4-4aa2-bcd4-f507b4d76c33.jpg)

