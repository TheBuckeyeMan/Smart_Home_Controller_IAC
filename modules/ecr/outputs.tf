#ECR Module
output "aws_ecr_id"{
    value = aws_ecr_repository.smart_home.id
}

output "aws_ecr_name"{
    value = aws_ecr_repository.smart_home.name
}

output "aws_ecr_arn"{
    value = aws_ecr_repository.smart_home.arn
}