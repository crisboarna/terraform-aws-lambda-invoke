#required otherwise circular dependency between IAM and Lambda
locals {
  lambda_function_name = "${var.lambda_function_name}"
}

module "lambda" {
  source = "./modules/lambda"

  #Setup
  region = "${var.region}"
  lambda_function_name = "${local.lambda_function_name}"
  lambda_description = "${var.lambda_description}"
  lambda_runtime = "${var.lambda_runtime}"
  lambda_handler = "${var.lambda_handler}"
  lambda_timeout = "${var.lambda_timeout}"
  lambda_code_s3_bucket_existing = "${var.lambda_code_s3_bucket_existing}"
  lambda_code_s3_bucket_new = "${var.lambda_code_s3_bucket_new}"
  lambda_code_s3_bucket_use_existing = "${var.lambda_code_s3_bucket_use_existing}"
  lambda_code_s3_key = "${var.lambda_code_s3_key}"
  lambda_code_s3_storage_class = "${var.lambda_code_s3_storage_class}"
  lambda_code_s3_bucket_visibility = "${var.lambda_code_s3_bucket_visibility}"
  lambda_zip_path = "${var.lambda_zip_path}"
  lambda_memory_size = "${var.lambda_memory_size}"

  #Internal
  lambda_role = "${module.iam.lambda_role_arn}"

  #Environment variables
  environmentVariables = "${var.environmentVariables}"

  #Tags
  tags = "${var.tags}"
}

module "iam" {
  source = "./modules/iam"

  #Setup
  lambda_name = "${local.lambda_function_name}"
  policy_arn_list = "${var.lambda_policy_arn_list}"
  policy_action_list = "${var.lambda_policy_action_list}"
}