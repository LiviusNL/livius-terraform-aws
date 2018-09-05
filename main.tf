provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
}

variable "availability_zones_east" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "availability_zones_west" {
  default = ["aws.us-west-2a", "aws.us-west-2b"]
}
resource "aws_instance" "frontend_east" {
  count = 2

  provider = "aws.us-east-1"
  availability_zone = "${var.availability_zones_west[count.index]}"

  ami = "ami-04681a1dbd79675a5"
  instance_type = "t1.micro"
  

  depends_on = ["aws_instance.backend_east"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "backend_east" {
  count = 2

  provider = "aws.us-east-1"
  availability_zone = "${var.availability_zones_west[count.index]}"

  ami = "ami-04681a1dbd79675a5"
  instance_type = "t1.micro"

  # lifecycle {
  #   prevent_destroy = true
  # }
}