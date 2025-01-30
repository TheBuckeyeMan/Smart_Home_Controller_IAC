data "aws_subnet" "smart_home_public_subnet"{
    filter{
        name = "tag:Name"
        values = ["smart_home_public_subnet"]
    }
}

data "aws_security_group" "smart_home_ec2_security_group"{
    filter{
        name = "tag:Name"
        values = ["smart_home_ec2_security_group"]
    }
}

data "aws_iam_instance_profile" "smart_home_controller_instance_profile" {
    name = "smart_home_controller_instance_profile"
}