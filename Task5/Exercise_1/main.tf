# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
    region = "us-east-1"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "udacity-t2" {
    ami = "ami-0f409bae3775dc8e5"
    instance_type = "t2.micro"
    subnet_id = "subnet-040de92f77e2a6196"
    count = 4
    tags = {
        Env = "Prod"
        Name = "Udacity T2"
    }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
# resource "aws_instance" "udacity-m4" {
#     ami = "ami-0f409bae3775dc8e5"
#     instance_type = "m4.large"
#     subnet_id = "subnet-040de92f77e2a6196"
#     count = 2
#     tags = {
#         Env = "Prod"
#         Name = "Udacity M4"
#     }
# }