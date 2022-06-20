data "aws_organizations_organization" "root_ou" {}

data "aws_availability_zones" "available" {}

data "aws_ssm_parameter" "ous" {
  name = "/aft/account-request/custom-fields/${var.environment}_ou"
}

#data "aws_ec2_transit_gateway" "tgw" {}
