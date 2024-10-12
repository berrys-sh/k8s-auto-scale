#!/bin/bash

# Check if a value was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <true|false>"
    exit 1
fi
TERRAFORM_DIR="./deployment/tf"

# Convert the input to lowercase (in case the user enters True/False)
IS_INSTALL_TERRAFORM=$(echo "$1" | tr '[:upper:]' '[:lower:]')
if [ "$IS_INSTALL_TERRAFORM" == "true" ]; then
    echo "Installing Terraform..."
    terraform_version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
    curl -O "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip"
    unzip terraform_${terraform_version}_linux_amd64.zip
    mkdir -p ~/bin
    mv terraform ~/bin/
    rm -f terraform_${terraform_version}_linux_amd64.zip
    terraform version
fi
cd ${TERRAFORM_DIR}
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

# Fetch Terraform output for NodeInstanceRole
export NODE_INSTANCE_ROLE=$(terraform output -raw NodeInstanceRole)
export LOAD_BALANCER_DNS_NAME=$(terraform output -raw LoadBalancerDNSName)

cd -

