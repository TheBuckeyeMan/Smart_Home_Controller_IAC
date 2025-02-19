#Connect Module
output "aws_decurity_group_id"{
    value = aws_security_group.smart_home_ec2_security_group.id
}



