data "template_file" "lambda_target_policy" {
  count = "${length(var.policy_action_list) == 1 ? 1 : 0}"
  template = "${file("${path.module}/lambda-policy.json")}"
  vars {
    policy_arn_list = "${join(", ", formatlist("\"%s\"", var.policy_arn_list))}"
    policy_action_list = "${join(", ", formatlist("\"%s\"", var.policy_action_list))}"
  }
}

resource "aws_iam_role" "lambda-role" {
  name = "${var.lambda_name}-Role"
  assume_role_policy = "${file("${path.module}/lambda-role.json")}"
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_logs_readwrite" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role = "${aws_iam_role.lambda-role.name}"
}

resource "aws_iam_role_policy" "lambda_invoke_lambda" {
  count = "${length(var.policy_action_list) == 1 ? 1 : 0}"
  name = "${aws_iam_role.lambda-role.name}-Policy"
  role = "${aws_iam_role.lambda-role.id}"
  policy = "${data.template_file.lambda_target_policy.rendered}"
}