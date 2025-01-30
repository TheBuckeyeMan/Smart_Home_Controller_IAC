#Create Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "smart_home_iot_core_log_group"{
    name = "smart_home_iot_core_log_group"
    retention_in_days = 7
}

#Alow IoT To send logs to cloudwatch
resource "aws_iot_logging_options" "iot_logging"{
    role_arn = data.aws_iam_role.smart_home_iot_core_cloudwatch_role.arn
    default_log_level = "INFO"
}

#IOT Core Resource
resource "aws_iot_thing" "rasberi_pi"{
    name = "SmartHomePi"
}

#IOT Policy
resource "aws_iot_policy" "pi_policy"{
    name = "smart_home_pi_policy"
    policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = ["iot:Connect", "iot:Publish", "iot:Subscribe", "iot:Receive"]
      Resource = "*"
    }]
  })
}


#IOT Topic Rule to allow it to trigger lambda function ON ERROR
resource "aws_iot_topic_rule" "iot_rule" {
    name = "iot_error_handler"
    sql = "SELECT * FROM 'iot/raspberry_pi/responses' WHERE status = 'error'"
    sql_version = "2016-03-23"
    enabled = true
    lambda {
      function_arn = var.Error_handling_lambda_arn.value
    }
}