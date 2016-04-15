variable "amis" {
  default = {
    us-east-1      = "ami-6d1c2007"
    us-west-2      = "ami-d2c924b2"
    us-west-1      = "ami-af4333cf"
    eu-central-1   = "ami-9bf712f4"
    eu-west-1      = "ami-7abd0209"
    ap-southeast-1 = "ami-f068a193"
    ap-southeast-2 = "ami-fedafc9d"
    ap-northeast-1 = "ami-eec1c380"
    sa-east-1      = "ami-26b93b4a"
  }
}

variable "build_number" {}
variable "region" {default = "us-east-1"}

provider "aws" {
  region = "${var.region}"
}

module "aws-mantl-testing" {
  source = "./terraform/aws"
  availability_zone = "${var.region}a"
  ssh_username = "centos"
  source_ami = "${lookup(var.amis, var.region)}"
  short_name = "mantl-ci-${var.build_number}"
  long_name = "ciscocloud-mantl-ci-${var.build_number}"

  control_count = 3
  worker_count = 2
  edge_count = 1
  kube_worker_count = 2
}
