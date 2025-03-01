output "template_provisional_iam_role_name_"{
    value = data.aws_iam_role.fleet_provisioning_role.name
}

output "template_provisional_iam_role_arn_"{
    value = data.aws_iam_role.fleet_provisioning_role.arn
}

output "template_provisional_iam_role_name_"{
    value = data.aws_iam_role.fleet_provisioning_role.arn
}

output "iot_fleet_raspberry_pi_termplate_arn" {
    value = aws_iot_provisioning_template.smart_home_fleet_template.arn
}

output "iot_fleet_raspberry_pi_termplate_id" {
    value = aws_iot_provisioning_template.smart_home_fleet_template.id
}

output "iot_fleet_raspberry_pi_termplate_name" {
    value = aws_iot_provisioning_template.smart_home_fleet_template.name
}

output "iot_fleet_raspberry_pi_disconnect_rule_arn" {
    value = aws_iot_topic_rule.device_disconnection_alert_rule.arn
}

output "iot_fleet_raspberry_pi_disconnect_rule_id" {
    value = aws_iot_topic_rule.device_disconnection_alert_rule.id
}

output "iot_fleet_raspberry_pi_disconnect_rule_name" {
    value = aws_iot_topic_rule.device_disconnection_alert_rule.name
}

# output "iot_fleet_raspberry_pi_disconnect_rule_associated_sns" {
#     value = aws_iot_topic_rule.device_disconnection_alert_rule.sns[0].target_arn
# }

output "iot_fleet_raspberry_pi_new_device_rule_arn" {
    value = aws_iot_topic_rule.device_registration_log_rule.arn
}

output "iot_fleet_raspberry_pi_new_device_rule_id" {
    value = aws_iot_topic_rule.device_registration_log_rule.id
}

output "iot_fleet_raspberry_pi_new_device_rule_name" {
    value = aws_iot_topic_rule.device_registration_log_rule.name
}

# output "iot_fleet_raspberry_pi_new_device_rule_associated_log_group" {
#     value = aws_iot_topic_rule.device_registration_log_rule.cloudwatch_logs.log_group_name
# }