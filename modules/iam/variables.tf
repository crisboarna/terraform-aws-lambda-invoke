variable "lambda_name" {
  description = "The name of the Lambda function"
}

variable "lambda_layers" {
  description = "Lambda Layer ARNS"
  type = list(string)
  default = []
}

variable "policy_arn_list" {
  description = "The ARNs of resources you want to allow execution of"
  type = "list"
}

variable "policy_action_list" {
  description = "The Actions you want to allow Lambda execution of"
  type = "list"
  default = ["lambda:InvokeFunction", "lambda:InvokeAsync"]
}