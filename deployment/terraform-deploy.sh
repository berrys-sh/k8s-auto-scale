#!/bin/bash

# Check if a value was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <true|false>"
    exit 1
fi
TERRAFORM_DIR="./tf"

# Convert the input to lowercase (in case the user enters True/False)
IS_INSTALL_TERRAFORM=$(echo "$1" | tr '[:upper:]' '[:lower:]')
if [ "$value" == "true" ]; then
    echo "Installing Terraform..."
    terraform_version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
    curl -O "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip"
    unzip terraform_${terraform_version}_linux_amd64.zip
    mkdir -p ~/bin
    mv terraform ~/bin/
    rm -f terraform_${terraform_version}_linux_amd64.zip
    terraform version
fi
# Step 2: Initialize the Terraform working directory
echo "Initializing Terraform..."
terraform init ${TERRAFORM_DIR}

# Step 3: Apply the Terraform configuration
echo "Applying Terraform plan..."
terraform plan ${TERRAFORM_DIR}

# Step 3: Apply the Terraform configuration
echo "Applying Terraform configuration..."
terraform apply -auto-approve ${TERRAFORM_DIR}

# Step 4: Output terraform
echo "terraform output:"
terraform output -chdir=${TERRAFORM_DIR}

