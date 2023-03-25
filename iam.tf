resource "aws_iam_role" "spot_eviction_event" {
  count              = var.enable ? 1 : 0
  name               = var.spot-evict-event-role-name
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_document.json
}

resource "aws_iam_role_policy" "cache_clear_purgeAllCache_policy"{
  name = "${var.spot-evict-event-role-name}RolePolicy"
  role = aws_iam_role.spot_eviction_event[0].id
  policy = data.aws_iam_policy_document.fastly-get-parameter_document.json
}

data "aws_iam_policy_document" "lambda_trust_document" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "fastly-get-parameter_document" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ssm:GetParameter"
    ]
    resources = ["arn:aws:logs:*:*:*", "*"]
  }
}

resource "aws_iam_role_policy_attachment" "spot_eviction_event_lambda_vpc_access_execution_policy" {
  count      = var.enable ? 1 : 0
  role       = aws_iam_role.spot_eviction_event[0].id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}