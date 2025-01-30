
#EC2 Instance Itself
resource "aws_instance" "smart_home_controller"{
    ami = "ami-2.0.20241113.1"
    instance_type = "t4g.micro"
    subnet_id = data.aws_subnet.smart_home_public_subnet.id
    security_groups = data.aws_security_group.smart_home_ec2_security_group.id
    associate_public_ip_address = true

    tags = {
        Name = "Smart Home Controller"
    }
}