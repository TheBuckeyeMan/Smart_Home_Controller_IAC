# Module iot_fleet
# This template makes the aws IoT Fleet template for the new rasberry pi devices to connect to after we make the template, we atttach the rules to the template below
#The main purpose is to set up the template to accept the pre installed certificate, then for the device to get a new one automatically for the topic
resource "aws_iot_provisioning_template" "smart_home_fleet_template"{
    name = "smart_home_fleet_template"
    description = "Template to set up new rasberry pi devices to the smart home"
    provisioning_role_arn = data.aws_iam_role.fleet_provisioning_role.arn

    template_body = jsonencode({
    Parameters = {
      SerialNumber = { Type = "String" }
    }
    Resources = {
      thing = {
        Type = "AWS::IoT::Thing"
        Properties = {
          ThingName     = { Ref = "SerialNumber" }
          ThingTypeName = "raspberry_pi"
        }
      }
      certificate = {
        Type = "AWS::IoT::Certificate"
        Properties = {
          CertificateId = { Ref = "AWS::IoT::Certificate::Id" }
          Status = "ACTIVE"
        }
      }
      policy = {
        Type = "AWS::IoT::Policy"
        Properties = {
          PolicyName = "smart_home_pi_policy"
        }
      }
      thingPrincipalAttachment = {
        Type = "AWS::IoT::ThingPrincipalAttachment"
        Properties = {
          ThingName = { Ref = "SerialNumber" }
          Principal = { Ref = "certificate" }
        }
      }
    }
  })
  tags = {
    Name = "smart_home_rasberry_pi_fleet_template"
  }
}


# IOT Rules for Lifecycle changes
#Detect when a device gets disconnected
resource "aws_iot_topic_rule" "device_disconnection_alert_rule" {
    name = "device_disconnection_alert"
    description = "IOT Role for the template for new devices that will detect when the device goes offline"
    #Im not convinced this is correct
    sql = "Select * FROM $aws/events/presence/disconnected/#"
    #sql = "SELECT * FROM \"$aws/events/presence/disconnected/+\""
    sql_version = "2016-03-23"
    enabled = true

    # sns {
    #     #We need to make this resource for it to be enabled
    #     target_arn = aws_sns_topic.iot_error_alerts.arn'
    #     rolerole_arn = data.aws_iam_role.iot_sns_role.arn
    #     message_format = "RAW"
    # }

    depends_on = [ 
        aws_iot_provisioning_template.smart_home_fleet_template 
    ]

    tags = {
        Name = "device_disconnection_alert_rule"
    }
}

# IOT Rule to Detect when a device is registered
resource "aws_iot_topic_rule" "device_registration_log_rule"{
    name = "device_registration_log"
    description = "IOT Rule to detect when a new device is registered"
    #NOt convinced this wont have to change
    #sql = "SELECT * FROM $aws/events/thing/+/created"
    sql = "SELECT * FROM \"$aws/events/thing/+/created\""
    sql_version = "2016-03-23"
    enabled = true

    # cloudwatch_logs {
    #   log_group_name = aws_cloudwatch_log_group.iot_registration_log_group.name #Need to create this Log Group
    #   role_arn = #Need to make this IAM Role to give permissions
    # }

    depends_on = [ 
        aws_iot_provisioning_template.smart_home_fleet_template 
    ]

    tags = {
        Name = "device_registration_log_rule"
    }

}