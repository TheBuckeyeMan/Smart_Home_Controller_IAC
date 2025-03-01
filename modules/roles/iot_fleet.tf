#IAM Role for the IoT Fleet Template and Rasberry Pi Devices themselves
resource "aws_iam_role" "fleet_provisioning_role"{
    name = "fleet_provisioning_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    Service = "iot.amazonaws.com"
                },
                Action = "sts:AssumeRole"
            }
        ]
    })

    tags = {
      Name = "fleet_provisioning_role"
    }
}

#Create Policy
resource "aws_iam_policy" "fleet_provisioning_policy"{
    name = "fleet_provisioning_policy"
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "iot:CreateThing",
          "iot:CreateCertificateFromCsr",
          "iot:AttachThingPrincipal",
          "iot:AttachPolicy"
        ]
        Resource = "*"
      }
    ]
  })
}


# Attach the policy
resource "aws_iam_role_policy_attachment" "fleet_provisioning_policy_attachment" {
    role = aws_iam_role.fleet_provisioning_role.name
    policy_arn = aws_iam_policy.fleet_provisioning_policy.arn
}
