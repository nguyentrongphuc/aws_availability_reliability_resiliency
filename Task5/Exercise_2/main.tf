provider "aws" {
  region = var.aws_region
}

# Archive a single file.
data "archive_file" "lambda_zip" {
    type        = "zip"
    source_file = "greet_lambda.py"
    output_path = var.lambda_output_path
}

data "aws_iam_policy_document" "log_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    effect = "Allow"
    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

# Lambda role configuration
resource "aws_iam_role" "lambda_exec_role" {
    name                = "lambda_exec_role"
    assume_role_policy  = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
            }
        ]
    }
    EOF
}


# Cloudwatch configuration
resource "aws_cloudwatch_log_group" "lambda_log_group" {
    name                = "/aws/lambda/${var.lambda_name}"
    retention_in_days   = 7
}

resource "aws_iam_policy" "lambda_logs_policy" {
    name    = "lambda_logs_policy"
    path    = "/"
    policy  = data.aws_iam_policy_document.log_topic_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
    role       = aws_iam_role.lambda_exec_role.name
    policy_arn = aws_iam_policy.lambda_logs_policy.arn
}


# Lambda function
resource "aws_lambda_function" "geeting_lambda" {
    function_name = var.lambda_name
    filename = data.archive_file.lambda_zip.output_path
    handler = var.lambda_handler
    runtime = "python3.8"
    role = aws_iam_role.lambda_exec_role.arn

    environment{
        variables = {
            greeting = "Hello World!"
        }
    }

    depends_on = [aws_iam_role_policy_attachment.lambda_logs_policy, aws_cloudwatch_log_group.lambda_log_group]
}
