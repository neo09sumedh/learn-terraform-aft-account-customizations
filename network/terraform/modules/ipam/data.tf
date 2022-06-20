data "aws_ssm_parameter" "ipam_cidr" {
  name = "/aft/account-request/custom-fields/${var.environment}_ipam_cidr"
}
data "aws_ssm_parameter" "ous" {
  name = "/aft/account-request/custom-fields/${var.environment}_ou"
}