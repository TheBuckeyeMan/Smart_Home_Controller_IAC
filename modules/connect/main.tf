resource "aws_security_group" "smart_home_ec2_security_group" {
    vpc_id = data.aws_vpc.smart_home_vpc.id

    #Specify Inbound HTTP/API Traffic from API Gateway, Lambda, EventBridgen to the Security group
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #This will be restricted later in API Gateway ID's
    }

    # Specify SSH if we want for debugging

    # Allow all outbound traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}