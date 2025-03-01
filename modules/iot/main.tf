#IoT Module
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
        Statement = [
            {
                Effect   = "Allow",
                Action   = ["iot:Connect"],
                Resource = "arn:aws:iot:us-east-2:339712758982:client/EC2-SmartHome-*"
            },
            {
                Effect   = "Allow",
                Action   = ["iot:Connect", "iot:Publish", "iot:Subscribe", "iot:Receive"],
                Resource = ["arn:aws:iot:us-east-2:339712758982:topic/iot/smart-home/#",
                            "arn:aws:iot:us-east-2:339712758982:topic/iot/smart-home/commands",
                            "arn:aws:iot:us-east-2:339712758982:topic/iot/smart-home/sportslights",
                            "arn:aws:iot:us-east-2:339712758982:topic/iot/smart-home/test",
                            "arn:aws:iot:us-east-2:339712758982:topic/iot/raspberry_pi/responses",
                            "arn:aws:iot:us-east-2:339712758982:topic/iot/raspberry_pi/errors",
                            "arn:aws:iot:us-east-2:339712758982:topic/$aws/things/*"
                ]
            }
        ]
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
#------------------------------------------------------------------------------------ IoT EC2 Application Certification-----------------------------------------------------------------------------------
#1. Create the certificate 
resource "aws_iot_certificate" "ec2_smart_home_cert" {
    active = true
}

#2. Attach the Certification to the AWS IoT Policy
#Attach the IOT Certificate to the IoT Policy - so the certificate policy attachment
resource "aws_iot_policy_attachment" "ec2_policy_attachment" {
    policy = aws_iot_policy.smart_home_pi_policy.name
    target = aws_iot_certificate.ec2_smart_home_cert.arn
}

#3. Create the aws secret Manager
resource "aws_secretsmanager_secret" "ec2_smart_home_mqtt_cert_for_controller" {
    name = "ec2_smart_home_mqtt_cert_for_controller"
    description = "Stores IoT Core certificate and private key for EC2 Smart Home Application"

    tags = {
        Name = "ec2_smart_home_mqtt_cert"
    }
}

#4. Store certificates inside of the certificate ma
#Essentially creating the certification files in aws secrets manager and assigning the corresponging values to them
resource "aws_secretsmanager_secret_version" "ec2_mqtt_cert_version" {
    secret_id = aws_secretsmanager_secret.ec2_smart_home_mqtt_cert_for_controller.id
    secret_string = jsonencode({
        certificate_pem = aws_iot_certificate.ec2_smart_home_cert.certificate_pem
        private_key = aws_iot_certificate.ec2_smart_home_cert.private_key
        public_key = aws_iot_certificate.ec2_smart_home_cert.public_key
    })
}

#------------------------------------------------------------------------------------ IoT EC2 Application Certification-----------------------------------------------------------------------------------
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