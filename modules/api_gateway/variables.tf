#api_gateway Module
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

variable "api_endpoints"{
  type = list(string)
  default = ["testec2","testpi","control","sendmessage","reconnect"]
}


#Create a map of API Gateway Resources and MEthods
# locals {
#   api_gateway_resources = { for ep in var.api_endpoints : ep => aws_api_gateway_resource[ep].id }
#   api_gateway_methods = { for ep in var.api_endpoints : ep => aws_api_gateway_method[ep].http_method }
#   api_gateway_method_responses = { for ep in var.api_endpoints : ep => aws_api_gateway_method_response.api_method_response[ep].status_code}
# }