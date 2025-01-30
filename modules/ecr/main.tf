resource "aws_ecr_repository" "smart_home" {
    name = "smart-home"

    tags = {
        Name = "smart-home"
    }
}