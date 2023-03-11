# parallel_copy
copying a file  after dividing it into partitions using durable function in azure

# initial setup
## login to azure subscription
az login

## switch to different subscription
az account list
az accout set --subscription "sub_name"

# terraform commands
## initialize provider
terraform init

## check config
terraform validate

## create a plan
terraform plan -out tfplan

## execute a plan
terraform apply "tfplan"

## destroy resources
terraform destroy

# things to look at
deploy code with terraform (null_resource): https://www.maxivanov.io/publish-azure-functions-code-with-terraform/