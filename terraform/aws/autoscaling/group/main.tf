variable "count" {default = "4"}
variable "count_format" {default = "%02d"}
variable "iam_profile" {default = "" }
variable "ec2_type" {default = "m3.medium"}
variable "ebs_volume_size" {default = "20"} # size is in gigabytes
variable "data_ebs_volume_size" {default = "20"} # size is in gigabytes
variable "role" {}
variable "short_name" {default = "mantl"}
variable "availability_zones" {}
variable "ssh_key_pair" {}
variable "datacenter" {}
variable "source_ami" {}
variable "security_group_ids" {}
variable "vpc_subnet_ids" {}
variable "ssh_username" {default = "centos"}
variable "launch_config_name_prefix" {default = "default-mantl-lc-"}
variable "autoscaling_group_name" {default = "default-mantl-asg"}
variable "autoscaling_load_balancers" {}

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix = "${var.launch_config_name_prefix}"
  image_id = "${var.source_ami}"
  instance_type = "${var.ec2_type}"
  iam_instance_profile = "${var.iam_profile}"
  key_name = "${var.ssh_key_pair}"
  security_groups = [ "${split(",", var.security_group_ids)}"]
  associate_public_ip_address = true
  root_block_device {
    delete_on_termination = true
    volume_size = "${var.ebs_volume_size}"
    volume_type = "gp2"
  }
  ebs_block_device {
    delete_on_termination = true
    device_name = "xvdh"
    volume_size = "${var.data_ebs_volume_size}"
    volume_type = "gp2"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name = "${var.autoscaling_group_name}"
  launch_configuration = "${aws_launch_configuration.launch_configuration.name}"
  availability_zones = [ "${split(",", var.availability_zones)}" ]
  max_size = "${var.count}"
  min_size = "${var.count}"
  desired_capacity = "${var.count}"
  health_check_type = "EC2"
  health_check_grace_period = "600"
  force_delete = true
  load_balancers = [ "${split(",", var.autoscaling_load_balancers)}" ]
  vpc_zone_identifier = [ "${split(",", var.vpc_subnet_ids)}" ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "sshUser"
    value = "${var.ssh_username}"
    propagate_at_launch = true
  }
  tag {
    key = "role"
    value = "${var.role}"
    propagate_at_launch = true
  }
  tag {
    key = "dc"
    value = "${var.datacenter}"
    propagate_at_launch = true
  }
  tag {
    key = "Name"
    value = "${var.short_name}-${var.role}"
    propagate_at_launch = true
  }
}