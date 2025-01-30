data "aws_instance" "smart_home_instance_public_ip"{
    filter{
        name = "tag:Name"
        values = ["smart_home_controller"]
    }
}