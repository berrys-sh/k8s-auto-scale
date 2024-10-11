#!/bin/bash

# install podman

# Update the package manager and install dependencies
echo "Updating package manager and installing dependencies..."
sudo yum update -y
sudo yum install -y yum-utils

# Add the Podman repository
echo "Adding Podman repository..."
sudo curl -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo \
    https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/CentOS_7/devel:kubic:libcontainers:stable.repo

# Install Podman
echo "Installing Podman..."
sudo yum install -y podman

# Verify installation
if command -v podman &> /dev/null
then
    echo "Podman successfully installed."
    podman --version
else
    echo "Podman installation failed."
    exit 1
fi


# install terraform
source ./deployment/terraform-deploy.sh true

# Set the region and cluster name (you can parameterize this as needed)
REGION="us-east-1"
#CLUSTER_NAME="demo-eks" # move to env


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

echo "Script completed successfully. Nodes should now be joined to the cluster."



# Build WC Server Image
./deployment/build-wc-server.sh


./deployment/helm-deploy.sh helm wc_server_new keda


