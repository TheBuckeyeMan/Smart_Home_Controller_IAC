#api_gateway Module
data "aws_instance" "smart_home_instance_public_ip"{
    filter{
        name = "tag:Name"
        values = ["smart_home_controller"]
    }

    filter {
        name   = "instance-state-name"
        values = ["running"] # Ensures you get only active instances
    }
}

data "aws_eip" "smart_home_elastic_ip" {
    filter{
        name = "tag:Name"
        values = ["smart_home_elastic_ip"]
    }
}

