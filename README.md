# parallel_copy
copying a file  after dividing it into partitions using durable function in azure

# initial setup
## login to azure subscription
az login

## switch to different subscription
az account list
az accout set --subscription "sub_name"

## navigate to terraform dir
cd infra/terraform

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

# remarks
code is also deployed with the null_resource in terraform using azure funtion core tool commmand