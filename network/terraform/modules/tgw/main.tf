resource "aws_ec2_transit_gateway" "tgw" {
  description = "${var.environment} Transit Gateway"
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support = "enable"
  tags = {
    Name = "${var.environment}-tgw"
  }
}

resource "aws_ram_resource_share" "tgw_share" {
  allow_external_principals = false
  name = "tgw-${var.environment}"

  depends_on = [
    aws_ec2_transit_gateway.tgw
  ]
}

resource "aws_ram_principal_association" "tgw_principal" {
    principal          = data.aws_ssm_parameter.ous.value
    resource_share_arn = aws_ram_resource_share.tgw_share.arn

  depends_on = [
    aws_ram_resource_share.tgw_share
  ]
}

resource "aws_ram_resource_association" "tgw_association" {
  resource_arn       = aws_ec2_transit_gateway.tgw.arn
  resource_share_arn = aws_ram_resource_share.tgw_share.arn

  depends_on = [
    aws_ram_resource_share.tgw_share
  ]
}
