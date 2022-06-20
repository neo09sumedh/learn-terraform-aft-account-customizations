data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

data "aws_ec2_transit_gateway" "tgw" {
    filter {
      name   = "managed_by"
      values = ["AFT"]
    }
}

data "aws_vpc_ipam_pool" "ipam_pool" {}
