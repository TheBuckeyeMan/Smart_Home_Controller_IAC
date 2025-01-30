#Create a rest gateway for the api gateway 
resource "aws_api_gateway_rest_api" "smart_home_api_gateway" {
    name = "SmartHomeControllerApi"
    description = "API Gateway fort smart home controller"
}

#Create the API Gateway Resource Itself
resource "aws_api_gateway_resource" "smart_home_resource"{
    rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
    parent_id = aws_api_gateway_rest_api.smart_home_api_gateway.root_resource_id
    path_part = "control"
}

resource "aws_api_gateway_method" "smart_home_method"{
    #Associated ta method with the gateway itself
    rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
    #Associate the method with the actual resource
    resource_id = aws_api_gateway_resource.smart_home_resource.id
    http_method = "POST"
    #Add authorization in the future as needed
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "smart_home_integration" {
    #Integrate and associate the rest gateway
    rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
    # Integrate the API Gateway Resource Itself
    resource_id = aws_api_gateway_resource.smart_home_resource.id
    #Associate the method of accessing the api gateway with the integration
    http_method = aws_api_gateway_method.smart_home_method.http_method
    integration_http_method = "POST"
    type = "HTTP"
    uri = "http://${data.aws_instance.smart_home_instance_public_ip.associate_public_ip_address}:8080/control"
}