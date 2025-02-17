#IoT Module
output "aws_iot_resource_id"{
    value = aws_iot_thing.rasberi_pi.id
}

output "aws_iot_resource_arn"{
    value = aws_iot_thing.rasberi_pi.arn
}

output "aws_iot_policy_name"{
    value = aws_iot_policy.smart_home_pi_policy.name
}

output "aws_iot_policy_id"{
    value = aws_iot_policy.smart_home_pi_policy.id
}
output "aws_iot_policy_arn"{
    value = aws_iot_policy.smart_home_pi_policy.arn
}

output "aws_iot_topic_rule_id"{
    value = aws_iot_topic_rule.iot_rule.id
}

output "aws_iot_topic_rule_arn"{
    value = aws_iot_topic_rule.iot_rule.arn
}

output "aws_iot_topic_rule_swl"{
    value = aws_iot_topic_rule.iot_rule.sql
}

output "aws_iot_topic_rule_Error_handling_lambda_arn"{
    value = var.Error_handling_lambda_arn
}

output "aws_iot_topic_rule_enabled"{
    value = aws_iot_topic_rule.iot_rule.enabled
}

output "smart_home_iot_log_group_arn"{
    value = aws_cloudwatch_log_group.smart_home_iot_core_log_group.arn
}

output "aws_iot_smart_home_logging_options_id"{
    value = aws_iot_logging_options.iot_logging.id
}

output "iot_certificate_arn" {
  description = "AWS IoT Certificate ARN"
  value       = aws_iot_certificate.smart_home_cert.arn
}

output "iot_certificate_id" {
  description = "AWS IoT Certificate ID"
  value       = aws_iot_certificate.smart_home_cert.id
}

output "iot_endpoint_address" {
    description = "The value of the endpoint we will use for the IOT Core endpoint for MQTT"
    value = data.aws_iot_endpoint.iot_endpoint.endpoint_address
}

output "iot_endpoint_type" {
    description = "The type of the endpoint for IOT Core"
    value = data.aws_iot_endpoint.iot_endpoint.endpoint_type
}

output "iot_endpoint_id" {
    description = "The ID of the endpoint"
    value = data.aws_iot_endpoint.iot_endpoint.id
}