#!/bin/bash -x

# Bash shell script to install Jenkins and terraform on Amazon linux 2023 

echo "Updating system packages..."
sudo dnf update -y

echo "Installing Java (OpenJDK 17)..."
sudo dnf install -y java-17-amazon-corretto

echo "Adding Jenkins repository..."
sudo curl -o /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "Installing Jenkins and git..."
sudo dnf install jenkins git -y 

echo "Enabling and starting Jenkins service..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install jq package for get Terraform version
sudo dnf install jq -y

# Get the latest version of Terraform from the releases page
TERRAFORM_VERSION=1.6.5
# The get the Latest version of Terraform, you can execute this command : 

# Download and install Terraform
sudo curl -O "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
sudo mv terraform /usr/local/bin/

# Clean up downloaded files
rm -f "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"