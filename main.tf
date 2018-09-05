provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
}

# resource "aws_instance" "example" {
#   ami           = "ami-2757f631"
#   instance_type = "t2.micro"
#
#   tags {
#     Name = "Lieuwe's Testing"
#     owner = "lhelmus@hashicorp.com"
#     TTL = 48
#   }
# }

variable "providers" {
  default = ["aws.us-east-1", "aws.us-west-2"]
}

variable "availability_zones" {
  type = "map"

  default = { 
    aws.us-east-1 = ["aws.us-east-1a", "aws.us-east-1b"]
    aws.us-west-2 = ["aws.us-west-2a", "aws.us-west-2b"]
}


resource "aws_instance" "frontend" {
  count = 4

  provider = "${variable.providers}"
  availability_zone = "${variable.availability_zones[${aws_instance.frontend.provider}]}"

  instance_type = "t1.micro"

  depends_on = "${aws_instance.backend}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "backend" {
  count = 4

  provider = "${variable.providers}"
  availability_zone = "${variable.availability_zones[${aws_instance.frontend.provider}]}"

  instance_type = "t1.micro"

  # lifecycle {
  #   prevent_destroy = true
  # }
}


