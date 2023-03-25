resource "aws_cloudwatch_log_group" "spotevictionevent-lambda_group" {
  name              = "/aws/lambda/SpotEvictionEventLambda"
  retention_in_days = var.log_retention
}

resource "aws_lambda_function" "spot-evict-event" {
  filename         = var.spot-evict-event-zip
  function_name    = "SpotEvictEventLambda"
  role             = aws_iam_role.spot_eviction_event[0].arn
  handler          = var.spot-evict-event
  source_code_hash = filebase64sha256(var.spot-evict-event-zip)
  runtime          = "go1.x"
  timeout          = var.timeout
  memory_size      = var.memory

  vpc_config {
    security_group_ids = [""]
    subnet_ids         = [""]
  }
  environment {
    variables = var.lambda_environment
  }
}

