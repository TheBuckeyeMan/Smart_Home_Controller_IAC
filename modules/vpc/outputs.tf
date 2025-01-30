output "aws_vpc_id" {
    value = aws_vpc.smart_home_vpc.id
}

output "aws_vpc_cidr_block"{
    value = aws_vpc.smart_home_vpc.cidr_block
}

output "aws_subnet_id"{
    value = aws_subnet.smart_home_public_subnet.id
}

output aws_subnet_cidr_block{
    value = aws_subnet.smart_home_public_subnet.cidr_block
}

output "aws_internet_gateway_id"{
    value = aws_internet_gateway.smart_home_igw.id
}

output "aws_route_table_id"{
    value = aws_route_table.smart_home_route_table.id
}

output "aws_route_id"{
    value = aws_route.smart_home_internet_access.id
}

output "aws_route_destination_cidr_block"{
    value = aws_route.smart_home_internet_access.destination_cidr_block
}

output "aws_route_associated_route_table"{
    value = aws_route.smart_home_internet_access.route_table_id
}

output "aws_route_associated_gateway_id"{
    value = aws_route.smart_home_internet_access.gateway_id
}
