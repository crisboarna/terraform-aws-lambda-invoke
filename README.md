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


***Attention***

Starting from version 1.1.0, this module targets Terraform 0.12+. If you are using Terraform <=v0.11 you must use up to version 1.0.0.

## Features

- Expandable Execution Role with unlimited policies that can be attached
  - Achieved by either creating own `aws_iam_role_policy_attachment` referencing exposed `lambda_role_arn` or by setting `lambda_policy_arn_list` and `lambda_policy_action_list` to list of desired Lambda's to be executed
- Code uploaded from local path
- Full configuration exposure while abstracting S3 and IAM permission handling

**NOTE**

This module is created with full customization by user.
- Can use either local filename path `lambda_file_name` or remote S3 bucket configuration.
- Supports Lambda Layers
- Supports VPC


I have tried to allow Lambda to call various types of services with differing actions by making `lambda_policy_arn_list` and `lambda_policy_action_list` to be lists of lists or maps but code became very complex and non-functional due to current Terraform limitations:
 - Modules do not accept `count` parameter
   - Could not create submodule creating the `aws_iam_role_policy` for every action-arn combination
 - `template_file` only accepts strings, not lists so have to interpolate every list to string
 - Due to above and `formatlist` evaluating parameters at compile time before dereferencing a `var.list[count.index]` it errors due to requiring at least 1 list parameter
   - This also cannot be circumvented by providing two lists as workaround (Ex: `formatlist("etc%setc", list(""), var.list[count.index])`)) as to provide size matching empty dummy list is very cumbersome and the underlying Go `fmt` package returns `%!(EXTRA type=value)` as output if wrong size given to `formatlist`
   - `element` cannot be used as it expects flat list and errors if presented with list of lists

Until any of these have been fixed, please use the output `lambda_role_id` to extend the created Lambda's IAM permissions.
## Usage
```hcl-terraform
module "lambda-invoke" {
  source  = "crisboarna/lambda-invoke/aws"
  version = "1.1.0"

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
```sh
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
  version = "v1.1.0"

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
  lambda_policy_arn_list = "${list(module.some_other_module.arn, module.some_another_module.arn}"
  lambda_policy_action_list = ["lamdba:InvokeFunction", "lambda:InvokeAsync"]
  lambda_vpc_security_group_ids = [aws_security_group.vpc_security_group.id]
  lambda_vpc_subnet_ids = [aws_subnet.vpc_subnet_a.id]
  lambda_layers = [data.aws_lambda_layer_version.layer.arn]

  #Tags
  tags = {
    project = "Awesome Project"
    managedby = "Terraform"
  }
  
  #Lambda Environment variables
  environment_variables = {
    NODE_ENV = "production"
  }
}
```

## Pull Requests
Pull requests are welcome !