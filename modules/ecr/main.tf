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
                AWS =  data.aws_iam_role.smart_home_lambda_role.arn # Replace with the actual Lambda IAM role name - Made in the Pi Roles module, so will not be deployed yet if doing this first time
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