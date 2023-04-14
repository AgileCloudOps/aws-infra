# CSYE6225 Network Structures and Cloud Computing

## Assignment: Infrastructure as a Code with Terraform

**Name**: Shivam Thabe

**NUID**: 002765286

# AWS CLI configuration with Terraform

## Introduction
This is an Infrastructure as a code project with terraform which created resources on aws cloud using terraform

## Prerequisites
- An AWS account
- AWS CLI installed on your local machine
- Access to your AWS access key ID and secret access key
- Terraform installed on your local machine

## AWS CLI
## Steps
    ```
    1. Open your terminal or command prompt.
    2. Type aws configure and press Enter.
    3. You will be prompted to enter your AWS Access Key ID, Secret Access Key, default region name, and default output format. If you do not have this information, you can obtain it from the AWS Management Console.
    4. Enter the requested information and press Enter.
    ```


## Terraform
## Clone this repository to your local machine
   ```
   git clone git@github.com:shivamt24/aws-infra.git
   ```
## Navigate to the project directory
   ```
   cd aws-infra/dev
   ```
## Install dependencies
   ```
   terraform init
   ```
## Plan the project
   ```
   terraform plan
   ```
## Create AWS resources
   ```
    terraform apply
   ```
## Delete AWS resources
   ```
    terraform destroy
   ```
## Command to import SSL Certificate
   ```
   aws acm import-certificate --certificate fileb://{path to certificate} --certificate-chain fileb://{path to certificate chain} --private-key fileb://{path to certificate private key}  --profile {profile name}
   ```