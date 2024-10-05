#!/bin/bash


# Step 1: install terraform
terraform_version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
curl -O "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip"
unzip terraform_${terraform_version}_linux_amd64.zip
mkdir -p ~/bin
mv terraform ~/bin/
terraform version

# Step 2: Initialize the Terraform working directory
echo "Initializing Terraform..."
terraform init

# Step 3: Apply the Terraform configuration
echo "Applying Terraform plan..."
terraform plan

# Step 3: Apply the Terraform configuration
echo "Applying Terraform configuration..."
terraform apply -auto-approve

# Step 4: Output terraform
echo "terraform output:"
terraform output  

