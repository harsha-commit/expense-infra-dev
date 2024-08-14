#!/bin/bash
component=$1
env=$2

dnf install ansible -y
pip3.9 install botocore boto3 # for connecting to AWS

# changes hosts to local, update variables
# environment is a reserved keyword for Ansible
ansible-pull -i localhost, -U https://github.com/harsha-commit/expense-ansible-terraform-practice.git main.yaml -e component=$component -e env=$env