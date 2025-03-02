data "aws_iam_role" "fleet_provisioning_role" {
  name = "fleet_provisioning_role"
}

# data "aws_iot_policy" "smart_home_pi_policy"{
#     name = "smart_home_pi_policy"
# }