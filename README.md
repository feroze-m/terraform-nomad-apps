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

![infra_diag](https://user-images.githubusercontent.com/103216595/162819662-c2b3016b-839d-4ae2-acf6-56aed45b6737.png)

