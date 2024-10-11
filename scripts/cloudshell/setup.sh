#!/bin/bash

# source ./deployment/set-env.sh && ./setup.sh

# Set .bashrc

file_path='./bashrc.txt'
# Append the file content to .bashrc
cat "$file_path" >> ~/.bashrc
echo "Content of $file_path has been added to ~/.bashrc."

# Clone the repository
git clone https://github.com/berrys-sh/k8s-auto-scale.git
cd k8s-auto-scale
git checkout develop

# Deploy the infrastructure
sh ./deployment/main.sh



