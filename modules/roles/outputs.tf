output "smart_home_ec2_role_arn" {
    value = aws_iam_role.smart_home_ec2_role.arn
}

output "iot_policy_arn"{
    value = aws_iam_policy.iot_policy.arn
}

#----------------------------------------------------------------------------------- Roles for EC2 Cloudwatch -----------------------------------------------------------------------------------
output "smart_home_controller_cloudwatch_role_id"{
    value = aws_iam_role.smart_home_controller_cloudwatch_role.id
}

output "smart_home_controller_cloudwatch_role_arn"{
    value = aws_iam_role.smart_home_controller_cloudwatch_role.arn
}

output "smart_home_controller_cloudwatch_policy_id"{
    value = aws_iam_policy.smart_home_controller_cloudwatch_logs_policy.id
}

output "smart_home_controller_cloudwatch_policy_arn"{
    value = aws_iam_policy.smart_home_controller_cloudwatch_logs_policy.arn
}

output "smart_home_controller_instance_profile_id"{
    value = aws_iam_instance_profile.smart_home_controller_instance_profile.id
}

output "smart_home_controller_instance_profile_arn"{
    value = aws_iam_instance_profile.smart_home_controller_instance_profile.arn
}
#----------------------------------------------------------------------------------- Roles for EC2 Cloudwatch -----------------------------------------------------------------------------------
#----------------------------------------------------------------------------------- Roles for API Gateway Cloudwatch -----------------------------------------------------------------------------------



#----------------------------------------------------------------------------------- Roles for API Gateway Cloudwatch -----------------------------------------------------------------------------------
#----------------------------------------------------------------------------------- Roles for IoT Core Cloudwatch -----------------------------------------------------------------------------------



#----------------------------------------------------------------------------------- Roles for IoT Core Cloudwatch -----------------------------------------------------------------------------------