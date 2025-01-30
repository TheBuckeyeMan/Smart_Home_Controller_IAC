output "aws_iot_resource_id"{
    value = aws_iot_thing.rasberi_pi.id
}

output "aws_iot_resource_arn"{
    value = aws_iot_thing.rasberi_pi.arn
}

output "aws_iot_policy_name"{
    value = aws_iot_policy.pi_policy.name
}

output "aws_iot_policy_id"{
    value = aws_iot_policy.pi_policy.id
}
output "aws_iot_policy_arn"{
    value = aws_iot_policy.pi_policy.arn
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
    value = aws_iot_topic_rule.iot_rule.lambda.function_arn
}

output "aws_iot_topic_rule_enabled"{
    value = aws_iot_topic_rule.iot_rule.enabled
}