#Create Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "smart_home_iot_core_log_group"{
    name = "smart_home_iot_core_log_group"
    retention_in_days = 7

    tags = {
        Name = "smart_home_iot_core_log_group"
    }
}

#Alow IoT To send logs to cloudwatch
resource "aws_iot_logging_options" "iot_logging"{
    role_arn = data.aws_iam_role.smart_home_iot_core_cloudwatch_role.arn
    default_log_level = "INFO"
}

#IOT Policy
resource "aws_iot_policy" "smart_home_pi_policy"{
    name = "smart_home_pi_policy"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
        Effect   = "Allow"
        Action   = ["iot:Connect", "iot:Publish", "iot:Subscribe", "iot:Receive"]
        Resource = "arn:aws:iot:us-east-2:339712758982:topic/iot/smart-home/#"
    }]
  })

  tags = {
        Name = "smart_home_pi_policy"
    }
}

#IOT Topic Rule to allow it to trigger lambda function ON ERROR
resource "aws_iot_topic_rule" "iot_rule" {
    name = "iot_error_handler"
    sql = "SELECT * FROM 'iot/raspberry_pi/responses' WHERE status = 'error'"
    sql_version = "2016-03-23"
    enabled = true
    lambda {
      function_arn = var.Error_handling_lambda_arn
    }

    tags = {
        Name = "iot_rule"
    }
}

resource "aws_iam_role_policy" "iot_logging_policy" {
    name = "IoTLoggingPolicy"
    role = data.aws_iam_role.smart_home_iot_core_cloudwatch_role.name

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect   = "Allow"
                Action   = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Resource = "*"
            }
        ]
    })
}

#------------------------------------------------------------------------------------ IoT Things-----------------------------------------------------------------------------------
#IOT Core "Thing" - This is the device itself
resource "aws_iot_thing" "rasberi_pi"{
    name = "SmartHomePi"
    attributes = {
      device_type = "raspberry_pi"
    }
}

#Create Certficate for Each Raspberry pi device as this is how each will authenticate
resource "aws_iot_certificate" "smart_home_cert" {
    active = true
}

#Attach the certificate we create to the pi device itself
resource "aws_iot_thing_principal_attachment" "pi_cert_attachment"{
    principal = aws_iot_certificate.smart_home_cert.arn
    thing = aws_iot_thing.rasberi_pi.name
}

#Attach policy to AWS IoT Core Policy to Certificate
resource "aws_iot_policy_attachment" "pi_policy_attachment" {
    policy = aws_iot_policy.smart_home_pi_policy.name
    target = aws_iot_certificate.smart_home_cert.arn
}

# 🔹 What happens?

# The policy is attached to an IoT certificate.
# Your Raspberry Pi authenticates using this certificate.
# The Spring Boot app can publish messages to IoT Core.