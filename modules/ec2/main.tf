#Cloudwatch Log Group for the EC2 Instance
resource "aws_cloudwatch_log_group" "smart_home_controller_log_group"{
    name = "smart_home_controller_log_group"
    retention_in_days = 7
}

#EC2 Instance Itself
resource "aws_instance" "smart_home_controller"{
    ami = "ami-2.0.20241113.1"
    instance_type = "t4g.micro"
    subnet_id = data.aws_subnet.smart_home_public_subnet.id
    security_groups = [data.aws_security_group.smart_home_ec2_security_group.id]
    associate_public_ip_address = true

    #Define EBS Volume - Automatic - We can specify, but we are choosing not to

    #The IAM Instance Profile
    iam_instance_profile = data.aws_iam_instance_profile.smart_home_controller_instance_profile.name

    #Tell Terraform we need to have the log group created first
    depends_on = [aws_cloudwatch_log_group.smart_home_controller_log_group] 

    #Configure Cloudwatch Agent
    # User Data Script to install and configure CloudWatch Agent
    user_data = <<-EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install -y amazon-cloudwatch-agent

        cat <<EOT > /opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json
        {
        "logs": {
            "logs_collected": {
            "files": {
                "collect_list": [
                {
                    "file_path": "/var/log/spring-app.log",
                    "log_group_name": "smart_home_controller_log_group",
                    "log_stream_name": "{instance_id}",
                    "timestamp_format": "%Y-%m-%d %H:%M:%S"
                }
                ]
            }
            }
        }
        }
        EOT

        sudo amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 \
            -c file:/opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json \
            -s
    EOF

    tags = {
        Name = "Smart Home Controller"
    }
}