#IoT Module
data "aws_iam_role" "smart_home_iot_core_cloudwatch_role" {
    name = "smart_home_iot_core_cloudwatch_role"
}

data "aws_iot_endpoint" "iot_endpoint" {
    endpoint_type = "iot:Data-ATS"
}

