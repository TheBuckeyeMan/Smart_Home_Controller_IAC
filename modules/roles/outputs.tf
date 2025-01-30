output "smart_home_ec2_role_arn" {
    value = aws_iam_role.smart_home_ec2_role.arn
}

output "iot_policy_arn"{
    value = aws_iam_policy.iot_policy.arn
}

