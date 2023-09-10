# TODO: Define the variable for aws_region
variable "aws_region" {
  default = "us-east-1"
}

variable "lambda_name" {
  default = "greet_lambda"
}

variable "lambda_handler" {
  default = "greet_lambda.lambda_handler"
}


variable "lambda_output_path" {
  default = "output.zip"
}