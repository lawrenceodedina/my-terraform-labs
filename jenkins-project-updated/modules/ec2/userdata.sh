#!/bin/bash -x

# Bash shell script to install Jenkins on Amazon linux 2023 

echo "Updating system packages..."
sudo dnf update -y

echo "Installing Java (OpenJDK 17)..."
sudo dnf install -y java-17-amazon-corretto

echo "Adding Jenkins repository..."
sudo curl -o /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "Installing Jenkins..."
sudo dnf install -y jenkins

echo "Enabling and starting Jenkins service..."
sudo systemctl enable jenkins
sudo systemctl start jenkins