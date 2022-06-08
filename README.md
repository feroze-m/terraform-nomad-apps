# terraform-nomad-apps
- Repo to deploy nomad-jobs in hashi cluster

# Pipeline
- This runs with github actions to deploy apps/services in the directory /apps
- We will be using nomad server url as provider in main.tf to refer to the cluster, where the apps will be deployed
- Github actions will run for any changes in ./

# .github
