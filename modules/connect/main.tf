#Connect Module
resource "aws_security_group" "smart_home_ec2_security_group" {
    vpc_id = data.aws_vpc.smart_home_vpc.id

    #Specify Inbound traffic from API Gateway to the Security group
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #This will be restricted later in API Gateway ID's
    }

    # Allow for SSH for Github Actions to Make Container Updates (Restrict to Github actions ip range)
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # TODO: Restrict this later to API Gateway ID
    }

    # Allow MQTT Over TLS (Port 8883)
    ingress {
        from_port   = 8883
        to_port     = 8883
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all outbound traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "smart_home_ec2_security_group"
    }
}