# Smart_Home_Controller_IAC
IAC for all required resources for the smart home controller and related resourcs in the project. Repo will be a multi module IAC repo where we can deploy each resource as neded, and also include a cd.yml for redeployments of the application to support cicd with auto apply. Multi Module repo

## Deployment Order
1.VPC
2.Connect
3.Roles
4.ECR - Do not need to delete if we need to destroy
5.Ec2
6.IOT
7.IOT_FLEET
7.API Gateway



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

## Code on the pi?
How can we deploy lightweight code to the pi
COnfigrue workflow
COnfigure CICD Pipeline




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


# CD.yml how it works here
## Docker Install
When we deploy the Ec2 Instance itself it wil install docker by itself
### How CD Deploys New Containers
1. CI builds new container, pushes to ECR
2. CD Will SSH into the EC2 Instance itself
3. CD will Stop Existing Container
4. CD Will remove the existing container
5. CD will pull the new contianer
6. CD will then run the new docker container 





create certificates in iot module
give them a policy for proper auth
store the certs in aws secrets manager
in app
pull secrets
store to temp file
use to connect to topic

# Rasberry pi fleet - How it works
1. Rasberry Pi Starts with a bootstrap Certificate(We pre install on the device)
2. The Device requests a new certificate from the AWS Fleet Provisioning
3. AWS IOT Core assigns a unique certificate to the rasberry pi
4. AWS IOT Core registeres the device in the fleet as a new IOT Thing
5. AWS IOT Core attaches policies to allow the device to communicate

# Rasberry pi fleet - Whats Required
1. Fleet Provisioning Template: Defines how the new devices are registered
2. IoT Policy: Grants permissions to publish/subscribe
3. IAM Role: Allows IoT TO create and Manage Devices
4. IoT Thing Registry: Tracks each registered rasberry pi

# Rasberruy Pi Post Device Registration and Post Authentication
1. AWS IoT Core assigns a broker endpoint to the device(Same broker endpoint as the Producer) //AWS IoT Core assigns a single MQTT broker endpoint per AWS account and region.
2. Rasberry pi subscribes to a topic to recieve messages
3. Rasberry pi publishes messages when actions are completed

# Rasberry pi response
1. The rasberry pi will publish responses Successufl data to /responses
1. The rasberry pi will publish responses Successufl data to /errors
2. IoT COre recieves messages
3. IoT Rule processes the response and Triggeres sns, email, slack if we have an error(Alternitibvle We can look into storing in DynamoDb in the future)
4. Log Response Messages

# Implementation for RAsberry pi devices post set up of controller
1. Configure AWS IoT Core Resource
2. Update IAM Roles + AWS Infra.


# Goals and Outcomes
1. Auto load new certificates on new devices
2. Detect offline Devices: Leverage IoT Lifecycle Events for best practice
2. Daily check to Monitor existing devices, send alert in the event one goes down `Yes! AWS IoT Core provides a feature called "Device Shadow" and "MQTT Last Will & Testament (LWT)"                                                                                   to track device connection status.
                                                                                    You can use AWS Lambda + IoT Device Shadow or IoT Lifecycle Events to detect if a device goes offline.` The AWS IoT Device Shadow stores a JSON document that tracks device state, including last connection timestamp. - not recomended for best practice


# Questions asked
Can IoT Core save directly to AwsDynamoDb or AWS S3 W/O Lambda - Yes


# Cost
## IoT Related
1$ per million Requests
Fleet Provisioning: a 10cent 1 time fee per device
Device Shaddow(If Used) 1.25$ per million Operations
 
 ## Dynamo
1.25$ per million write requests

## SNS
50cent per million publishes
Email: Free
SMS 0.0075$ per message
Webhook: Free



# Notes 
1. Create iot template 2. Create the DynamoDB to store serial Numbers 3. Create the lambdas to read form the dynamo db(Will be used to validate the device is a registered device before issuing a new certificate), as well as a lambda to pull the dynamo, check if the new serial number already exists and if so exit, if not post to the dynamo db 4. Set up the api gateway and configure it for the lambdas(SO the cicd process can send a post request to api gateway using a secure key(To make it secure, a static api key is fine) and then pass in the serial number to be posted in the database(Via the lambda). 5. Create the dummy certificate that aws template will recognize for us to use to get the new cert. After all of that is set up, We will finally have the option to send the dummy cert to get the new cert and function as expected, then I can work on the application correct? 

Verification that the bootstrap certificate is validated properly to take place in the lambda function