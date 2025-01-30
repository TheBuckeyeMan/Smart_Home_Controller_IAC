output "smart_home_api_gateway_arn"{
    value = aws_api_gateway_rest_api.smart_home_api_gateway.arn
}

output "smart_home_api_gateway_id"{
    value = aws_api_gateway_rest_api.smart_home_api_gateway.id
}

output "aws_api_gateway_resource_id"{
    value = aws_api_gateway_resource.smart_home_resource.id
}

output "aws_api_gateway_resource.arn"{
    value = aws_api_gateway_resource.smart_home_resource.arn
}

output "aws_api_gateway_resource_parent"{
    value = aws_api_gateway_resource.smart_home_resource.parent_id
}

output "aws_api_gateway_resource_associated_api_gateway_gateway_id"{
    value = aws_api_gateway_resource.smart_home_resource.rest_api_id
}

output "aws_api_gateway_method_id"{
    value = aws_api_gateway_method.smart_home_method.id
}

output "smart_home_api_gateway_integration_id"{
    value = aws_api_gateway_integration.smart_home_integration.id
}

output "smart_home_api_gateway_integration_associated_rest_api_gateway_id"{
    value = aws_api_gateway_integration.smart_home_integration.rest_api_id
}

output "smart_home_api_gateway_integration_associated_resource_id"{
    value = aws_api_gateway_integration.smart_home_integration.resource_id
}

output "smart_home_api_gateway_integration_associated_http_method"{
    value = aws_api_gateway_integration.smart_home_integration.http_method
}

output "smart_home_api_gateway_integration_associated_integrated_http_method" {
    value = aws_api_gateway_integration.smart_home_integration.integration_http_method
}

output "smart_home_api_gateway_integration_associated_type"{
    value = aws_api_gateway_integration.smart_home_integration.type
}

output "smart_home_api_gateway_integration_associated_uri"{
    value = aws_api_gateway_integration.smart_home_integration.uri
}
