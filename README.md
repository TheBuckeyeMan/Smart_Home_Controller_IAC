# Smart_Home_Controller_IAC
IAC for all required resources for the smart home controller and related resourcs in the project. Repo will be a multi module IAC repo where we can deploy each resource as neded, and also include a cd.yml for redeployments of the application to support cicd with auto apply. Multi Module repo


## IAM Roles related to the EC2 and VPC
permissions to accept incomming requests form 
event bridge
api gateway
lambda
Other

Ensure we have access to trigger
Lambda
AWS IoC Core


## AWS EC2 Configuration
Instance Type: t4c.nano

### EBS Config

## VPC Details

### Public Subnet Details
#### Elastic IP Detail
Public IP Address

#### Security Group Details(Only Non Confidential)
Whats whitelisted and whats not


### Elastic IP Detail

## Rasberi pi device info
How to set up? 
what does AWS IoT Need?



## IAM Roles assocuated with the AWS IoT Core
permissions to get triggered from ec2
Permissions to trigger lambda
permission to trigger rasberi pi? Maybe?


## AWS IoT Core Details
Registration Detials
Detail IoT Policy to allow MQTT Trafic
Detail IoT Certificate

### Things Registration List


### Command Topic

### Response Topic

## Iam roles for if fail email error 
Allow AWS IoT To Trigger

## Lambda Details
