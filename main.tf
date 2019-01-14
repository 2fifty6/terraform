provider "aws" {
  region = "${var.aws_region}"
  max_retries = 30
}

terraform {
  backend "s3" {
    region="${var.aws_region}"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket}"
    key = "${var.vpc_state_key}"
    region = "${aws_region}"
  }
}

module "bogus" {/*{{{*/
    source = "./bogus"
    ami_id = "${var.ami_id}"
    aws_key_name = "${var.aws_key_name}"
    environment = "${var.environment}"
    iam_instance_profile = "${data.terraform_remote_state.vpc.instance_profile}"
    instance_type = "${var.instance_type}"
    port = "${var.port}"
    scaling_max = "${var.scaling_max}"
    scaling_min = "${var.scaling_min}"

    # Remote State
    azs = "${data.terraform_remote_state.vpc.azs}"
    domain = "${data.terraform_remote_state.vpc.domain}"
    private_subnet_cidrs = "${data.terraform_remote_state.vpc.private_subnet_cidrs}"
    private_subnets = "${data.terraform_remote_state.vpc.private_subnets}"
    private_zone_id = "${data.terraform_remote_state.vpc.private_zone_id}"
    vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  # Tags
    client = "${var.client}"
    expiration = "${var.expiration}"
}
/*}}}*/
