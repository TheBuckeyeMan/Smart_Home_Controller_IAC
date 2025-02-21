#Roles Module
#----------------------------------------------------------------------------------- Roles for EC2 -----------------------------------------------------------------------------------
#Make the Role for the Smart home EC2 Instance
resource "aws_iam_role" "smart_home_ec2_role"{
    name = "smart_home_ec2_role"
    assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
        Name = "smart_home_ec2_role"
    }
}

#IoT Role Policy
resource "aws_iam_policy" "iot_policy"{
    name = "smart_home_iot_policy"
    description = "Allow Ec2 to talk to AWS IoT Core"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect   = "Allow",
                Action   = ["iot:Connect"],
                Resource = "arn:aws:iot:us-east-2:339712758982:client/EC2-SmartHome-*"
            },
            {
                Effect   = "Allow",
                Action   = ["iot:Publish", "iot:Subscribe", "iot:Receive"],
                Resource = "arn:aws:iot:us-east-2:339712758982:topic/iot/smart-home/#"
            },
            {
                Effect   = "Allow",
                Action   = ["iot:TestAuthorization"], 
                Resource = "*"
            }
        ]
    })

  tags = {
        Name = "iot_policy"
    }
}

#Attach the IoT olicy to the Smart Home Ec2 Role Itself
resource "aws_iam_role_policy_attachment" "iot_attach"{
    role = aws_iam_role.smart_home_ec2_role.name
    policy_arn = aws_iam_policy.iot_policy.arn
}
#----------------------------------------------------------------------------------- Roles for EC2-----------------------------------------------------------------------------------
#----------------------------------------------------------------------------------- Roles for EC2 to have permission to get ECR Images-----------------------------------------------------------------------------------
resource "aws_iam_policy" "ecr_policy_for_ec2"{
    name = "ecr_policy_for_ec2"
    description = "Allows EC2 to authenticate and pull Docker images from ECR"
    
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect   = "Allow"
                Action   = [
                    "ecr:GetAuthorizationToken"  # Allows EC2 to authenticate with ECR
                ]
                Resource = "*"
            },
            {
                Effect   = "Allow"
                Action   = [
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage"
                ]
                Resource = "arn:aws:ecr:us-east-2:339712758982:repository/smart-home"
            }
        ]
    })

    tags = {
        Name = "ecr_policy_for_ec2"
    }
}

resource "aws_iam_role_policy_attachment" "ecr_attach"{
    role = aws_iam_role.smart_home_ec2_role.name
    policy_arn = aws_iam_policy.ecr_policy_for_ec2.arn
}


#----------------------------------------------------------------------------------- Roles for EC2 to have permission to get ECR Images-----------------------------------------------------------------------------------
#----------------------------------------------------------------------------------- Roles for EC2 Cloudwatch-----------------------------------------------------------------------------------
#Create Cloudwatch Role
resource "aws_iam_role" "smart_home_controller_cloudwatch_role"{
    name = "smart_home_controller_cloudwatch_role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
        Name = "smart_home_controller_cloudwatch_role"
    }
}

#Create Cloudwatch Policy
resource "aws_iam_policy" "smart_home_controller_cloudwatch_logs_policy"{
    name = "smart_home_cloudwatch_logs_policy"
    description = "Allow EC2 to write to cloudwatch logs"
    policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      Resource = "arn:aws:logs:*:*:*"
    }]
  })

  tags = {
        Name = "smart_home_controller_cloudwatch_logs_policy"
    }
}

#Attach Cloudwatch Policy
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy"{
    role = aws_iam_role.smart_home_controller_cloudwatch_role.name
    policy_arn = aws_iam_policy.smart_home_controller_cloudwatch_logs_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy_to_ec2"{
    role = aws_iam_role.smart_home_ec2_role.name
    policy_arn = aws_iam_policy.smart_home_controller_cloudwatch_logs_policy.arn
}

#Attach to EC2 Instance Profile - EC2 does NOT Need to be created first in order to deploy
resource "aws_iam_instance_profile" "smart_home_controller_instance_profile"{
    name = "smart_home_controller_instance_profile"
    role = aws_iam_role.smart_home_ec2_role.name
    tags = {
        Name = "smart_home_controller_instance_profile"
    }
}
#----------------------------------------------------------------------------------- Roles for EC2 Cloudwatch -----------------------------------------------------------------------------------
#----------------------------------------------------------------------------------- Policy for EC2 to have permission to AWS Secrets Manager -----------------------------------------------------------------------------------
resource "aws_iam_policy" "secretsmanager_policy"{
    name = "secretsmanager_policy"
    description = "Allows EC2 to retrieve secrets from AWS Secrets Manager"

    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:us-east-2:339712758982:secret:ec2_smart_home_mqtt_cert_for_controller-*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_secretsmanager_policy_to_ec2" {
    role = aws_iam_role.smart_home_ec2_role.name
    policy_arn = aws_iam_policy.secretsmanager_policy.arn
}
#----------------------------------------------------------------------------------- Policy for EC2 to have permission to AWS Secrets Manager-----------------------------------------------------------------------------------

#----------------------------------------------------------------------------------- Roles for API Gateway Cloudwatch -----------------------------------------------------------------------------------
resource "aws_iam_role" "smart_home_api_gateway_cloudwatch_role"{
    name = "smart_home_api_gateway_cloudwatch_role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "apigateway.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  tags = {
        Name = "smart_home_api_gateway_cloudwatch_role"
    }
}

#IAM Policy
resource "aws_iam_policy" "smart_home_api_gateway_cloudwatch_policy"{
    name = "smart_home_api_gateway_cloudwatch_policy"
    description = "Allows API Gateway to write logs to CloudWatch"

    policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Effect   = "Allow",
        Action   = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
        ],
        Resource = "arn:aws:logs:*:*:*"
    }]
    })
    tags = {
        Name = "smart_home_api_gateway_cloudwatch_policy"
    }
}

#Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_api_gateway_cloudwatch_policy"{
    role = aws_iam_role.smart_home_api_gateway_cloudwatch_role.name
    policy_arn = aws_iam_policy.smart_home_api_gateway_cloudwatch_policy.arn
}

resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.smart_home_api_gateway_cloudwatch_role.arn
  depends_on = [
    aws_iam_role.smart_home_api_gateway_cloudwatch_role,
    aws_iam_role_policy_attachment.attach_api_gateway_cloudwatch_policy
  ]
}

#----------------------------------------------------------------------------------- Roles for API Gateway Cloudwatch -----------------------------------------------------------------------------------
#----------------------------------------------------------------------------------- Roles for IoT Core Cloudwatch -----------------------------------------------------------------------------------
#IAM Role for IoT Core Resource
resource "aws_iam_role" "smart_home_iot_core_cloudwatch_role" {
    name = "smart_home_iot_core_cloudwatch_role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "iot.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
        Name = "smart_home_iot_core_cloudwatch_role"
    }
}

#Policy for IoT Cloudwatch Core 
resource "aws_iam_policy" "smart_home_iot_core_cloudwatch_policy" {
    name = "smart_home_iot_core_cloudwatch_policy"
    description = "Allows IoT Core to write logs to CloudWatch"
  
    policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Effect   = "Allow",
        Action   = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
        ],
        Resource = "arn:aws:logs:*:*:*"
    }]
    })

    tags = {
        Name = "smart_home_iot_core_cloudwatch_policy"
    }
}


#Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_iot_cloudwatch_policy"{
    role = aws_iam_role.smart_home_iot_core_cloudwatch_role.name
    policy_arn = aws_iam_policy.smart_home_iot_core_cloudwatch_policy.arn
}
#----------------------------------------------------------------------------------- Roles for IoT Core Cloudwatch -----------------------------------------------------------------------------------