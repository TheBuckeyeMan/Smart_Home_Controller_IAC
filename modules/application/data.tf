#NO TERRAFORM REQUIRED AS APP UPDATES WORK AS FOLLOWS
#1. CI builds new container, pushes to ECR
#2. CD Will SSH into the EC2 Instance itself
#3. CD will Stop Existing Container
#4. CD Will remove the existing container
#5. CD will pull the new contianer
#6. CD will then run the new docker container 