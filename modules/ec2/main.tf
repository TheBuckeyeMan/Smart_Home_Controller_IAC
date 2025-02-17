#EC2 Module
#Cloudwatch Log Group for the EC2 Instance
resource "aws_cloudwatch_log_group" "smart_home_controller_log_group"{
    name = "smart_home_controller_log_group"
    retention_in_days = 7

    tags = {
        Name = "smart_home_controller_log_group"
    }
}

#Create Private Key Locally for SSH KeyPair
resource "tls_private_key" "smart_home_controller_private_key"{
    algorithm = "RSA"
    rsa_bits = 4096
}

#Create AWS Key Pair using the Generated Public Key
resource "aws_key_pair" "smart_home_controller_ssh_key"{
    key_name = "smart_home_controller_ssh_key"
    public_key = tls_private_key.smart_home_controller_private_key.public_key_openssh

    tags = {
        Name = "smart_home_controller_ssh_key"
    }
}

#EC2 Instance Itself
resource "aws_instance" "smart_home_controller"{
    ami = "ami-0c649d908a8acc79f"
    instance_type = "t4g.micro"
    subnet_id = data.aws_subnet.smart_home_public_subnet.id
    security_groups = [data.aws_security_group.smart_home_ec2_security_group.id]
    associate_public_ip_address = true

    #Define EBS Volume - Automatic - We can specify, but we are choosing not to

    # Assign the generated SSH key to EC2
    key_name = aws_key_pair.smart_home_controller_ssh_key.key_name

    #The IAM Instance Profile
    iam_instance_profile = data.aws_iam_instance_profile.smart_home_controller_instance_profile.name

    #Tell Terraform we need to have the log group created first
    depends_on = [aws_cloudwatch_log_group.smart_home_controller_log_group] 

    #Configure Cloudwatch Agent
    # User Data Script to install and configure CloudWatch Agent, Docker, AWS CLI
    user_data = <<-EOF
        #!/bin/bash
        echo "Updating system packages..."
        sudo yum update -y

        echo "Installing CloudWatch Agent..."
        sudo yum install -y amazon-cloudwatch-agent

        echo "Installing Docker..."
        sudo amazon-linux-extras enable docker
        sudo yum install -y docker
        sudo systemctl start docker
        sudo systemctl enable docker
        sudo usermod -aG docker ec2-user

        echo "Installing AWS CLI..."
        sudo yum install -y aws-cli

        echo "Fetching CloudWatch Agent config..."
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
            -c file:/opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json -s
    EOF

    tags = {
        Name = "smart_home_controller"
        aws_application = "SmartHomeController"
    }
}