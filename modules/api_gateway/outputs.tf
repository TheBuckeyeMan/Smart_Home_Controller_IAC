output "smart_home_api_gateway_arn"{
    value = aws_api_gateway_rest_api.smart_home_api_gateway.arn
}

output "smart_home_api_gateway_id"{
    value = aws_api_gateway_rest_api.smart_home_api_gateway.id
}

output "aws_api_gateway_resource_id"{
    value = aws_api_gateway_resource.smart_home_resource.id
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

output "smart_home_api_gateway_deployment_id"{
    value = aws_api_gateway_deployment.smart_home_api_gateway_deployment.id
}

output "smart_home_api_gateway_stage_arn"{
    value = aws_api_gateway_stage.smart_home_api_gateway_stage.arn
}

output "smart_home_api_gateway_stage_id"{
    value = aws_api_gateway_stage.smart_home_api_gateway_stage.id
}

output "smart_home_api_gateway_cloudwatch_destination_arn"{
    value = aws_api_gateway_stage.smart_home_api_gateway_stage.access_log_settings.0.destination_arn
}

output "smart_home_api_gateway_cloudwatch_log_group_arn"{
    value = aws_cloudwatch_log_group.smart_home_api_gateway_cloudwatch_log_group.arn
}

output "smart_home_api_gateway_cloudwatch_log_group_id"{
    value = aws_cloudwatch_log_group.smart_home_api_gateway_cloudwatch_log_group.id
}