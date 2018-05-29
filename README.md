# Terraform AWS Lambda Invoke

### Terraform module for AWS Lambda with expandable execution
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
![stability-stable](https://img.shields.io/badge/stability-stable-green.svg)

## Table of Contents
* [Features](#features)
* [Usage](#usage)
* [Deployment](#deployment)
* [Example](#example)
* [Pull Requests](#pull-requests)
## Features

- Expandable Execution Role with unlimited policies that can be attached
  - Achieved by either creating own `aws_iam_role_policy_attachment` referencing exposed `lambda_role_arn` or by setting `lambda_arns` to list of desired Lambda's to be executed
- Code uploaded from local path
- Full configuration exposure while abstracting S3 and IAM permission handling

## Usage
```hcl-terraform
module "lambda-invoke" {
  source  = "crisboarna/lambda-invoke/aws"
  version = "0.1.0"

  # insert the 10 required variables here
}
```

## Deployment
1. Run build process to generate Lambda ZIP file locally to match `lambda_zip_path` variable path
2. Provide all needed variables from `variables.tf` file or copy paste and change example below
3. Create/Select Terraform workspace before deployment
4. Run `terraform plan -var-file="<.tfvars file>` to check for any errors and see what will be built
5. Run `terraform apply -var-file="<.tfvars file>` to deploy infrastructure

**Example Deployment Script**
```js
#!/usr/bin/env bash

if [[ ! -d .terraform ]]; then
  terraform init
fi
if ! terraform workspace list 2>&1 | grep -qi "$ENVIRONMENT"; then
  terraform workspace new "$ENVIRONMENT"
fi
terraform workspace select "$ENVIRONMENT"
terraform get
terraform plan -var-file=$1
terraform apply -var-file=$1
```

## Example
```hcl-terraform
module "lambda_module" {
  source  = "crisboarna/terraform-aws-lambda-invoke"
  version = "v0.1.0"

  #Global
  region = "eu-west-1"
  project = "Awesome Project"

  #Lambda
  lambda_function_name = "Awesome Endpoint"
  lambda_description = "Awesoapi-gateway-lambda-dynamodbme HTTP Endpoint Lambda"
  lambda_runtime = "nodejs8.10"
  lambda_handler = "dist/bin/lambda.handler"
  lambda_timeout = 30
  lambda_code_s3_bucket_new = "awesome-project-bucket"
  lambda_code_s3_key = "awesome-project.zip"
  lambda_code_s3_storage_class = "ONEZONE_IA"
  lambda_code_s3_bucket_visibility = "private"
  lambda_zip_path = "../../awesome-project.zip"
  lambda_memory_size = 256
  lambda_arns = ['arn:aws:lambda:us-east-1:123456789012:function:ProcessKinesisRecords',
  'arn:aws:lambda:us-east-1:123456789012:function:ProcessKinesisRecords:$PROD']
  
  #Tags
  tags = {
    project = "Awesome Project"
    managedby = "Terraform"
  }
  
  #Lambda Environment variables
  environmentVariables = {
    NODE_ENV = "production"
  }
}
```

## Pull Requests
Pull requests are welcome !