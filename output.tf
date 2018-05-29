output "lambda_role_arn" {
  value = "${module.iam.lambda_role_arn}"
}

output "lambda_name" {
  value = "${module.lambda.lambda_name}"
}

output "lambda_arn" {
  value = "${module.lambda.lambda_arn}"
}

output "lambda_role_id" {
  value = "${module.iam.lambda_role_id}"
}