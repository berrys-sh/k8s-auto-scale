#!/bin/bash


# Get ECR Repo URI
ECR_REPO_URI=$(aws ecr describe-repositories --repository-names demo-eks-repo --query 'repositories[0].repositoryUri' --output text)

# Build the docker image
WC_SERVER_IMAGE_VERSION=$(jq -r '.version' ./ms/wc-server/package.json)
WC_SERVER_IMAGE_TAG=wc-server:${WC_SERVER_IMAGE_VERSION}
WC_SERVER_IMAGE_URI=${ECR_REPO_URI}:${WC_SERVER_IMAGE_TAG}
echo "Building docker image: ${WC_SERVER_IMAGE_URI}"
docker build -t ${WC_SERVER_IMAGE_URI} ./ms/wc-server

echo "Pushing docker image: ${WC_SERVER_IMAGE_URI}"
docker push ${WC_SERVER_IMAGE_URI}
docker rmi ${WC_SERVER_IMAGE_URI}

# Update the helm chart values
sed -i 's|repository:.*|repository: '"${ECR_REPO_URI}"'|' ./deployment/helm/charts/wc-server/values.yaml
sed -i 's|tag:.*|tag: '"${WC_SERVER_IMAGE_TAG}"'|' ./deployment/helm/charts/wc-server/values.yaml
