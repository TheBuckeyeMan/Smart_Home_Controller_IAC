#Make the Role for the Smart home EC2 Instance
resource "aws_iam_role" "smart_home_ec2_role"{
    name = "smart_home_ec2_role"
    assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

#IoT Role Policy
resource "aws_iam_policy" "iot_policy"{
    name = "smart_home_iot_policy"
    description = "Allow Ec2 to talk to AWS IoT Core"
    policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = ["iot:Publish", "iot:Subscribe", "iot:Connect", "iot:Receive"]
      Resource = "*"
    }]
  })
}

#Attach the IoT olicy to the Smart Home Ec2 Role Itself
resource "aws_iam_role_policy_attachment" "iot_attach"{
    role = aws_iam_role.smart_home_ec2_role.name
    policy_arn = aws_iam_policy.iot_policy.arn
}

