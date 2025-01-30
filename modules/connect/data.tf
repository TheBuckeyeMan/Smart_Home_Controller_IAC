data "aws_vpc" "smart_home_vpc"{
    filter {
        name = "tag:Name"
        values = ["smart_home_vpc"]
    }
}