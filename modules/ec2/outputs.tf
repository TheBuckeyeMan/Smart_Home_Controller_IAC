#EC2 Module
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

output "smart_home_controller_associated_cloudwatch_arn"{
    value = aws_cloudwatch_log_group.smart_home_controller_log_group.arn
}

output "smart_home_controller_private_key_id"{
    value = tls_private_key.smart_home_controller_private_key.id
}

output "smart_home_controller_ssh_key_arn"{
    value = aws_key_pair.smart_home_controller_ssh_key.arn
}

output "smart_home_controller_ssh_key_id"{
    value = aws_key_pair.smart_home_controller_ssh_key.id
}

output "smart_home_controller_ssh_key_name"{
    value = aws_key_pair.smart_home_controller_ssh_key.key_name
}

output "smart_home_controller_ssh_key_public_key"{
    value = aws_key_pair.smart_home_controller_ssh_key.public_key
}

output "ec2_ssh_private_key" {
  description = "SSH Private Key for EC2"
  value       = tls_private_key.smart_home_controller_private_key.private_key_pem
  sensitive = true
}