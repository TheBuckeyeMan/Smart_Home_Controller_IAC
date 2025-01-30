output "aws_instance_id"{
    value = aws_instance.smart_home_controller.id
}

output "aws_instance_associated_subnet"{
    value = aws_instance.smart_home_controller.subnet_id
}

output "aws_instance_associated__security_group"{
    value = aws_instance.smart_home_controller.security_groups
}

output "aws_instance_type" {
    value = aws_instance.smart_home_controller.instance_type
}

output "aws_instance_ami"{
    value = aws_instance.smart_home_controller.ami
}

output "aws_instance_public_ip"{
    value = aws_instance.smart_home_controller.public_ip
}

output "smart_home_controller_associated_instance_profile"{
    value = aws_instance.smart_home_controller.iam_instance_profile
}

output "smart_home_controller_associated_instance_profile"{
    value = aws_instance.smart_home_controller.iam_instance_profile
}

output "smart_home_controller_associated_cloudwatch_arn"{
    value = aws_cloudwatch_log_group.smart_home_controller_log_group.arn
}