variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "region" {
    description = "Desired Region"
    type = string
    default = "us-east-2"
}

variable "Error_handling_lambda_arn"{
    default = "arn:aws:lambda:us-east-2:339712758982:function:youtube-service-7"
    type = string
    description = "AWS Lambda ARN that will get triggered if we recieve an error response form the pi -- UPDATE AS THIS IS PLACEHOLDER RIGHT NOW"
}