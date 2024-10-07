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


#!/bin/bash

# Set the region and cluster name (you can parameterize this as needed)
REGION="us-east-1"
CLUSTER_NAME="demo-eks"

# Fetch Terraform output for NodeInstanceRole
NODE_INSTANCE_ROLE=$(terraform output -raw NodeInstanceRole)

if [ -z "$NODE_INSTANCE_ROLE" ]; then
  echo "Error: NodeInstanceRole not found in Terraform output"
  exit 1
fi

echo "NodeInstanceRole ARN: $NODE_INSTANCE_ROLE"

# Step 1: Update kubeconfig to access the EKS cluster
echo "Updating kubeconfig for EKS cluster..."
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME

if [ $? -ne 0 ]; then
  echo "Error: Failed to update kubeconfig"
  exit 1
fi

# Step 2: Download the aws-auth ConfigMap
echo "Downloading aws-auth ConfigMap..."
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/aws-auth-cm.yaml

if [ $? -ne 0 ]; then
  echo "Error: Failed to download aws-auth ConfigMap"
  exit 1
fi

# Step 3: Update the aws-auth ConfigMap with the NodeInstanceRole
echo "Updating aws-auth-cm.yaml with NodeInstanceRole ARN..."

sed -i "s|<ARN of instance role (not instance profile)>|$NODE_INSTANCE_ROLE|g" aws-auth-cm.yaml

if grep -q "$NODE_INSTANCE_ROLE" aws-auth-cm.yaml; then
  echo "ConfigMap updated successfully"
else
  echo "Error: Failed to update ConfigMap"
  exit 1
fi

# Step 4: Apply the ConfigMap to allow worker nodes to join the cluster
echo "Applying updated aws-auth ConfigMap..."
kubectl apply -f aws-auth-cm.yaml

if [ $? -ne 0 ]; then
  echo "Error: Failed to apply aws-auth ConfigMap"
  exit 1
fi

# Wait for nodes to join the cluster
echo "Waiting for nodes to join the cluster (2-3 minutes)..."
sleep 180

# Step 5: Verify that worker nodes have joined the cluster
echo "Checking node status..."
kubectl get nodes -o wide

if [ $? -ne 0 ]; then
  echo "Error: Failed to retrieve node information"
  exit 1
fi

echo "Script completed successfully. Nodes should now be joined to the cluster."


