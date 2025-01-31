#Create Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "smart_home_api_gateway_cloudwatch_log_group"{
    name = "smart_home_api_gateway_cloudwatch_log_group"
    retention_in_days = 7

    tags = {
        Name = "smart_home_api_gateway_cloudwatch_log_group"
    }
}

#Create a rest gateway for the api gateway 
resource "aws_api_gateway_rest_api" "smart_home_api_gateway" {
    name = "SmartHomeControllerApi"
    description = "API Gateway fort smart home controller"

    tags = {
        Name = "smart_home_api_gateway"
    }
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
    uri = "http://${data.aws_instance.smart_home_instance_public_ip.public_ip}:8080/control"
    
}

#Create API Gateway Stage so that we can have a publicly accessable URL, and so cloudwatch works
resource "aws_api_gateway_deployment" "smart_home_api_gateway_deployment"{
    rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
    
    triggers = {
        redeployment = sha1(jsonencode(aws_api_gateway_rest_api.smart_home_api_gateway.body))
    }

    lifecycle {
      create_before_destroy = true
    }

    depends_on = [
        aws_api_gateway_integration.smart_home_integration,
        aws_api_gateway_integration.test_integration
    ]
}

#Add stages to the api gateway to expose publically and  for cloudwatch
resource "aws_api_gateway_stage" "smart_home_api_gateway_stage"{
    stage_name = "prod"
    rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
    deployment_id = aws_api_gateway_deployment.smart_home_api_gateway_deployment.id

    access_log_settings {
    destination_arn = aws_cloudwatch_log_group.smart_home_api_gateway_cloudwatch_log_group.arn
    format = jsonencode({
      requestId       = "$context.requestId",
      ip              = "$context.identity.sourceIp",
      caller          = "$context.identity.caller",
      user            = "$context.identity.user",
      requestTime     = "$context.requestTime",
      httpMethod      = "$context.httpMethod",
      resourcePath    = "$context.resourcePath",
      status          = "$context.status",
      protocol        = "$context.protocol",
      responseLength  = "$context.responseLength"
    })
  }
  
  tags = {
        Name = "smart_home_api_gateway_stage"
    }
}
#--------------------------------------------------------------------Test Endpoint----------------------------------------------------------------
resource "aws_api_gateway_resource" "test_resource"{
    rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
    parent_id = aws_api_gateway_rest_api.smart_home_api_gateway.root_resource_id
    path_part = "test" #EDIT WITH THE REQUEST TO API GATEWAY TYPE
}

#Define MEthod
resource "aws_api_gateway_method" "test_method"{
    rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
    resource_id = aws_api_gateway_resource.test_resource.id
    http_method = "GET"
    authorization = "NONE" #Require Authorization as needed
}

#Integrate the new Endpoint to API Gateway to Forward to EC2
resource "aws_api_gateway_integration" "test_integration" {
    rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
    resource_id = aws_api_gateway_resource.test_resource.id
    http_method = aws_api_gateway_method.test_method.http_method
    integration_http_method = "POST" #EDIT WITH THE REQUEST TO API GATEWAY TYPE
    type = "HTTP"
    uri = "http://${data.aws_instance.smart_home_instance_public_ip.public_ip}:8080/test"
}
#--------------------------------------------------------------------Test Endpoint----------------------------------------------------------------

#--------------------------------------------------------------Add New Endpoints Template ----------------------------------------------------------------
#Add Depends on Clause to aws_api_gateway_deployment resource
#Create API Gateway Resource for new Endpoint
# resource "aws_api_gateway_resource" "<endpoint name>_resource"{
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     parent_id = aws_api_gateway_rest_api.smart_home_api_gateway.root_resource_id
#     path_part = "<endpoint name>" #EDIT WITH THE REQUEST TO API GATEWAY TYPE
# }

# #Define MEthod
# resource "aws_api_gateway_method" "<endpoint name>_method"{
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     resource_id = aws_api_gateway_resource.<endpoint name>_resource.id
#     http_method = "POST"
#     authorization = "NONE" #Require Authorization as needed
# }

# #Integrate the new Endpoint to API Gateway to Forward to EC2
# resource "aws_api_gateway_integration" "<endpoint name>_integration" {
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     resource_id = aws_api_gateway_resource.<endpoint name>_resource.id
#     http_method = aws_api_gateway_method.<endpoint name>_method.http_method
#     integration_http_method = "POST" #EDIT WITH THE REQUEST TO API GATEWAY TYPE
#     type = "HTTP"
#     uri = "http://${data.aws_instance.smart_home_instance_public_ip.public_ip}:8080/<endpoint name>"
# }
#--------------------------------------------------------------Add New Endpoints Template ----------------------------------------------------------------
