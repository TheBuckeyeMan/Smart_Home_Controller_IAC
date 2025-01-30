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