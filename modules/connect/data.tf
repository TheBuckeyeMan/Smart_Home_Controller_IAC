data "aws_vpc" "smart_home_vpc"{
    filter {
        name = "tag:Name"
        values = ["smart_home_vpc"]
    }
}

data "aws_ip_ranges" "api_gateway_ip_addresses"{
    regions = [var.region]
    services = ["APIGATEWAY"]
}
