#TAGS
variable "tags" {
  type = "map"
  description = "Tags for lambda"
  default = {}
}


#Environment variables
variable "environmentVariables" {
  type = "map"
  default = {
    "DEFAULT" = "DEFAULT"
  }
  description = "Azure Bot Subscription ID"
}

#SETUP

#Global
variable "region" {
  description = "Region to deploy in"
}

#Lambda
variable "lambda_function_name" {
  description = "Local path to Lambda zip code"
}

variable "lambda_description" {
  default = ""
  description = "Lambda description"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
}

variable "lambda_handler" {
  description = "Lambda handler path"
}

variable "lambda_timeout" {
  description = "Maximum runtime for Lambda"
  default = 30
}

variable "lambda_code_s3_bucket_new" {
  default = "defaultBucket"
  description = "S3 bucket with source code"
}

variable "lambda_code_s3_bucket_use_existing" {
  default = "true"
  description = "Boolean flag to specify whether to use 'lambda_code_s3_bucket_new' and create new bucket or to use 'lambda_code_s3_bucket_existing and use existing S3 bucket and now a generate new one"
}

variable "lambda_code_s3_bucket_existing" {
  description = "Existing 'aws_s3_bucket.bucket'"
}

variable "lambda_code_s3_key" {
  description = "Location of Lambda code in S3 bucket"
}

variable "lambda_code_s3_storage_class" {
  description = "Lambda code S3 storage class"
  default = "ONEZONE_IA"
}

variable "lambda_code_s3_bucket_visibility" {
  default = "private"
  description = "S3 bucket ACL"
}

variable "lambda_zip_path" {
  description = "Local path to Lambda zip code"
}

variable "lambda_memory_size" {
  description = "Lambda memory size"
}

variable "lambda_policy_arn_list" {
  description = "The ARNs of resources you want to allow execution of"
  type = "list"
  default = ["arn:aws:lambda:*:*:*:*"]
}

variable "lambda_policy_action_list" {
  description = "The Actions you want to allow Lambda execution of"
  type = "list"
  default = ["lambda:InvokeFunction", "lambda:InvokeAsync"]
}