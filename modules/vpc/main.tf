#Create VPC
resource "aws_vpc" "smart_home_vpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "smart_home_vpc"
    }
}

#Give the VPC a public Subnet
resource "aws_subnet" "smart_home_public_subnet"{
    vpc_id = aws_vpc.smart_home_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "smart_home_public_subnet"
    }
}

##Give the VPC an Internet gateway
resource aws_internet_gateway "smart_home_igw"{
    vpc_id = aws_vpc.smart_home_vpc.id
    tags = {
        Name = "smart_home_igw"
    }
}

#Give the VPC a Route Table
resource "aws_route_table" "smart_home_route_table"{
    vpc_id = aws_vpc.smart_home_vpc.id
    tags = {
        Name = "smart_home_route_table"
    }
}


#Assign a route to the route table, route it to the internet gateway above
resource "aws_route" "smart_home_internet_access" {
    route_table_id = aws_route_table.smart_home_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.smart_home_igw.id
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "smart_home_public_route" {
    subnet_id      = aws_subnet.smart_home_public_subnet.id
    route_table_id = aws_route_table.smart_home_route_table.id
}


