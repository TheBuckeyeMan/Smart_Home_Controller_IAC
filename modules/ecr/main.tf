#ECR Module
resource "aws_ecr_repository" "smart_home" {
    name = "smart-home"

    tags = {
        Name = "smart-home"
    }
}


resource "aws_ecr_repository_policy" "smart_home_ecr_policy"{
    repository = aws_ecr_repository.smart_home.name
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "AllowEC2Pull"
                Effect = "Allow"
                Principal = {
                    AWS = "arn:aws:iam::339712758982:role/smart_home_ec2_role"
                }
                Action = [
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage"
                ]
            },
            {
                Sid    = "AllowLambdaPull"
                Effect = "Allow"
                Principal = {
                AWS = [
                    "arn:aws:iam::339712758982:role/pi_side_lambda_task_1_role",
                    "arn:aws:iam::339712758982:role/pi_side_lambda_task_2_role"  # Add additional roles here for ECR Access for Lambda
                ]
                }
                Action = [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage"
                ]
            }
        ]
    })
}