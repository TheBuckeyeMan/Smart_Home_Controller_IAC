#Create Cloudwatch Group
resource "aws_cloudwatch_log_group" "smart_home_api_gateway_logs"{
    name = "smart_home_api_gateway_logs"
    retention_in_days = 7
    tags = {
        Name = "smart_home_api_gateway_logs"
    }
}

#Create API Gateway Definition(Outline for API Gateway)
resource "aws_api_gateway_rest_api" "smart_home_api"{
    name = "smart_home_api"
    description = "API Gateway to allow traffic to trigger the smart home api"
    tags = { 
        Name = "smart_home_api" 
    }
}

#Create API Gateway Resources(Endpoints) - Associate with Rest API - Adds to aws_api_gateway_rest_api.smart_home_api
resource "aws_api_gateway_resource" "endpoints"{
    for_each = toset(var.api_endpoints)
    rest_api_id = aws_api_gateway_rest_api.smart_home_api.id
    parent_id = aws_api_gateway_rest_api.smart_home_api.root_resource_id
    path_part = each.value
}

#Create API Gateway Methods (WHat methods will out api gateway accept) - Assocoate with API Gateway "smart home api" - Adds to aws_api_gateway_rest_api.smart_home_api
resource "aws_api_gateway_method" "smart_home_methods"{
    for_each = aws_api_gateway_resource.endpoints
    rest_api_id = aws_api_gateway_rest_api.smart_home_api.id
    resource_id = each.value.id
    http_method = "GET"
    authorization = "NONE"
}

#Create API Gateway Integrations - Integrate the Endpoint with the Rest API smart home api - Adds to aws_api_gateway_rest_api.smart_home_api
resource "aws_api_gateway_integration" "smart_home_api_gateway_integration" {
    for_each = aws_api_gateway_resource.endpoints
    rest_api_id = aws_api_gateway_rest_api.smart_home_api.id
    resource_id = each.value.id
    http_method = aws_api_gateway_method.smart_home_methods[each.key].http_method
    integration_http_method = "GET"
    type = "HTTP"
    uri = "http://${data.aws_instance.smart_home_instance_public_ip.public_ip}:8080/prod/${each.key}"
}

#Create API Gateway Method Responses - Creates 200 success message - Adds to aws_api_gateway_rest_api.smart_home_api
resource "aws_api_gateway_method_response" "smart_home_api_gateway_response" {
    for_each = aws_api_gateway_resource.endpoints
    rest_api_id = aws_api_gateway_rest_api.smart_home_api.id
    resource_id = each.value.id
    http_method = aws_api_gateway_method.smart_home_methods[each.key].http_method
    status_code = "200"

    response_models = {
        "application/json" = "Empty"
    }
}

#Create API Gateway Integration Responses - Adds response body to api response - Adds to aws_api_gateway_rest_api.smart_home_api
resource "aws_api_gateway_integration_response" "smart_home_api_gateway_integration_response" {
    for_each = aws_api_gateway_resource.endpoints
    rest_api_id = aws_api_gateway_rest_api.smart_home_api.id
    resource_id = each.value.id
    http_method = aws_api_gateway_method.smart_home_methods[each.key].http_method
    status_code = "200"

    response_templates = {
        "application/json" = <<EOF
    {
        "message": "$input.body"
    }
    EOF
    }
}

#Create API Gateway Deployment - This deplpys the api gateway specified
resource "aws_api_gateway_deployment" "smart_home_api_gateway_deployment"{
    rest_api_id = aws_api_gateway_rest_api.smart_home_api.id
    triggers = {
        redeployment = sha1(jsonencode(aws_api_gateway_rest_api.smart_home_api.body))
    }
    lifecycle {
      create_before_destroy = true
    }
    depends_on = [
        aws_api_gateway_integration.smart_home_api_gateway_integration,
        aws_api_gateway_integration_response.smart_home_api_gateway_integration_response
    ]
}

resource "aws_api_gateway_stage" "smart_home_api_gateway_stage"{
    stage_name = "prod"
    rest_api_id = aws_api_gateway_rest_api.smart_home_api.id
    deployment_id = aws_api_gateway_deployment.smart_home_api_gateway_deployment.id
    access_log_settings {
        destination_arn = aws_cloudwatch_log_group.smart_home_api_gateway_logs.arn
        format = jsonencode({
            requestId      = "$context.requestId",
            ip             = "$context.identity.sourceIp",
            user           = "$context.identity.user",
            requestTime    = "$context.requestTime",
            httpMethod     = "$context.httpMethod",
            resourcePath   = "$context.resourcePath",
            status         = "$context.status",
            responseLength = "$context.responseLength"
        })
    }
}

# #Create Cloudwatch Log Group
# resource "aws_cloudwatch_log_group" "smart_home_api_gateway_cloudwatch_log_group"{
#     name = "smart_home_api_gateway_cloudwatch_log_group"
#     retention_in_days = 7

#     tags = {
#         Name = "smart_home_api_gateway_cloudwatch_log_group"
#     }
# }

# #Create a rest gateway for the api gateway 
# resource "aws_api_gateway_rest_api" "smart_home_api_gateway" {
#     name = "SmartHomeControllerApi"
#     description = "API Gateway fort smart home controller"

#     tags = {
#         Name = "smart_home_api_gateway"
#     }
# }

# #Create the API Gateway Resource Itself
# resource "aws_api_gateway_resource" "smart_home_resource"{
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     parent_id = aws_api_gateway_rest_api.smart_home_api_gateway.root_resource_id
#     path_part = "control"
# }

# resource "aws_api_gateway_method" "smart_home_method"{
#     #Associated ta method with the gateway itself
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     #Associate the method with the actual resource
#     resource_id = aws_api_gateway_resource.smart_home_resource.id
#     http_method = "POST"
#     #Add authorization in the future as needed
#     authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "smart_home_integration" {
#     #Integrate and associate the rest gateway
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     # Integrate the API Gateway Resource Itself
#     resource_id = aws_api_gateway_resource.smart_home_resource.id
#     #Associate the method of accessing the api gateway with the integration
#     http_method = aws_api_gateway_method.smart_home_method.http_method
#     integration_http_method = "POST"
#     type = "HTTP"
#     uri = "http://${data.aws_instance.smart_home_instance_public_ip.public_ip}:8080/prod/control"
# }

# #Create API Gateway Stage so that we can have a publicly accessable URL, and so cloudwatch works
# resource "aws_api_gateway_deployment" "smart_home_api_gateway_deployment"{
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
    
#     triggers = {
#         redeployment = sha1(jsonencode(aws_api_gateway_rest_api.smart_home_api_gateway.body))
#     }

#     lifecycle {
#       create_before_destroy = true
#     }

#     depends_on = [
#         aws_api_gateway_integration.smart_home_integration,
#         aws_api_gateway_integration.test_integration,
#         aws_api_gateway_integration.test_pi_integration
#     ]
# }

# #Add stages to the api gateway to expose publically and  for cloudwatch
# resource "aws_api_gateway_stage" "smart_home_api_gateway_stage"{
#     stage_name = "prod"
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     deployment_id = aws_api_gateway_deployment.smart_home_api_gateway_deployment.id

#     access_log_settings {
#     destination_arn = aws_cloudwatch_log_group.smart_home_api_gateway_cloudwatch_log_group.arn
#     format = jsonencode({
#       requestId       = "$context.requestId",
#       ip              = "$context.identity.sourceIp",
#       caller          = "$context.identity.caller",
#       user            = "$context.identity.user",
#       requestTime     = "$context.requestTime",
#       httpMethod      = "$context.httpMethod",
#       resourcePath    = "$context.resourcePath",
#       status          = "$context.status",
#       protocol        = "$context.protocol",
#       responseLength  = "$context.responseLength"
#     })
#   }
  
#   tags = {
#         Name = "smart_home_api_gateway_stage"
#     }
# }


# # #Associate 200 code with each of the endpoints
# resource "aws_api_gateway_method_response" "api_method_response"{
#     for_each = toset(var.api_endpoints)
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     resource_id = local.api_gateway_resources[each.key]
#     http_method = local.api_gateway_methods[each.key]
#     status_code = "200"
#     response_models = {
#     "application/json" = "Empty"
#   }
# }

# #Associate the Response Message with a 200 Response
# resource "aws_api_gateway_integration_response" "api_integration_response" {
#     for_each = toset(var.api_endpoints)
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     resource_id = local.api_gateway_resources[each.key]
#     http_method = local.api_gateway_methods[each.key]
#     status_code = local.api_gateway_method_responses[each.key]

#     response_templates = {
#     "application/json" = <<EOF
#     {
#     "message": "$input.body"
#     }
#     EOF
#     }
# }










# #--------------------------------------------------------------------Test EC2 Endpoint----------------------------------------------------------------
# resource "aws_api_gateway_resource" "test_ec2_resource"{
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     parent_id = aws_api_gateway_rest_api.smart_home_api_gateway.root_resource_id
#     path_part = "testec2" #EDIT WITH THE REQUEST TO API GATEWAY TYPE
# }

# #Define Method
# resource "aws_api_gateway_method" "test_method"{
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     resource_id = aws_api_gateway_resource.test_ec2_resource.id
#     http_method = "GET"
#     authorization = "NONE" #Require Authorization as needed
# }

# #Integrate the new Endpoint to API Gateway to Forward to EC2
# resource "aws_api_gateway_integration" "test_integration" {
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     resource_id = aws_api_gateway_resource.test_ec2_resource.id
#     http_method = aws_api_gateway_method.test_method.http_method
#     integration_http_method = "GET" #EDIT WITH THE REQUEST TO API GATEWAY TYPE
#     type = "HTTP"
#     uri = "http://${data.aws_instance.smart_home_instance_public_ip.public_ip}:8080/prod/testec2"
# }
# #--------------------------------------------------------------------Test EC2 Endpoint----------------------------------------------------------------


# #-------------------------------------------------------------- Test PI Endpoint ----------------------------------------------------------------
# # Add Depends on Clause to aws_api_gateway_deployment resource
# # Create API Gateway Resource for new Endpoint
# resource "aws_api_gateway_resource" "test_pi_resource"{
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     parent_id = aws_api_gateway_rest_api.smart_home_api_gateway.root_resource_id
#     path_part = "testpi" #EDIT WITH THE REQUEST TO API GATEWAY TYPE
# }

# #Define Method
# resource "aws_api_gateway_method" "test_pi_method"{
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     resource_id = aws_api_gateway_resource.test_pi_resource.id
#     http_method = "GET"
#     authorization = "NONE" #Require Authorization as needed
# }

# #Integrate the new Endpoint to API Gateway to Forward to EC2
# resource "aws_api_gateway_integration" "test_pi_integration" {
#     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
#     resource_id = aws_api_gateway_resource.test_pi_resource.id
#     http_method = aws_api_gateway_method.test_pi_method.http_method
#     integration_http_method = "GET" #EDIT WITH THE REQUEST TO API GATEWAY TYPE
#     type = "HTTP"
#     uri = "http://${data.aws_instance.smart_home_instance_public_ip.public_ip}:8080/prod/testpi"
# }
# #-------------------------------------------------------------- Test PI Endpoint ----------------------------------------------------------------

# #--------------------------------------------------------------Add New Endpoints Template ----------------------------------------------------------------
# #Add Depends on Clause to aws_api_gateway_deployment resource
# ##ALSO Add new endpoint to api_endpoints variables in variables.tf
# #Create API Gateway Resource for new Endpoint
# # resource "aws_api_gateway_resource" "<endpoint name>_resource"{
# #     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
# #     parent_id = aws_api_gateway_rest_api.smart_home_api_gateway.root_resource_id
# #     path_part = "<endpoint name>" #EDIT WITH THE REQUEST TO API GATEWAY TYPE
# # }

# # #Define MEthod
# # resource "aws_api_gateway_method" "<endpoint name>_method"{
# #     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
# #     resource_id = aws_api_gateway_resource.<endpoint name>_resource.id
# #     http_method = "POST"
# #     authorization = "NONE" #Require Authorization as needed
# # }

# # #Integrate the new Endpoint to API Gateway to Forward to EC2
# # resource "aws_api_gateway_integration" "<endpoint name>_integration" {
# #     rest_api_id = aws_api_gateway_rest_api.smart_home_api_gateway.id
# #     resource_id = aws_api_gateway_resource.<endpoint name>_resource.id
# #     http_method = aws_api_gateway_method.<endpoint name>_method.http_method
# #     integration_http_method = "POST" #EDIT WITH THE REQUEST TO API GATEWAY TYPE
# #     type = "HTTP"
# #     uri = "http://${data.aws_instance.smart_home_instance_public_ip.public_ip}:8080/prod/<endpoint name>"
# # }




# #--------------------------------------------------------------Add New Endpoints Template ----------------------------------------------------------------
