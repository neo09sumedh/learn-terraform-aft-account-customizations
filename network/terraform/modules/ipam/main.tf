locals {
    child_subnets = cidrsubnets(data.aws_ssm_parameter.ipam_cidr.value, 2, 2)
}

variable "ipam_regions" {
  type    = list
  default = ["us-east-1"]
}


resource "aws_vpc_ipam" "ipam" {
    description = "${var.environment} IPAM" 
    dynamic operating_regions {
      for_each = var.ipam_regions
      content {
        region_name = operating_regions.value
      }
    }
}

resource "aws_vpc_ipam_pool" "parent_pool" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.ipam.private_default_scope_id
  allocation_default_netmask_length = 24
  allocation_max_netmask_length = 28
  allocation_min_netmask_length = 23
  auto_import = true
}

resource "aws_vpc_ipam_pool_cidr" "parent_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.parent_pool.id
  cidr         = data.aws_ssm_parameter.ipam_cidr.value
}

resource "aws_vpc_ipam_pool" "child_pool" {
  address_family      = "ipv4"
  ipam_scope_id       = aws_vpc_ipam.ipam.private_default_scope_id
  locale              = "us-east-1"
  source_ipam_pool_id = aws_vpc_ipam_pool.parent_pool.id
  allocation_default_netmask_length = 24
  allocation_max_netmask_length = 28
  allocation_min_netmask_length = 23
  auto_import = true
  depends_on = [
    aws_vpc_ipam_pool.parent_pool
  ]
}

resource "aws_vpc_ipam_pool_cidr" "child_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.child_pool.id
  cidr         = local.child_subnets[0]
}

resource "aws_ram_resource_share" "ipam_pool" {
  allow_external_principals = false
  name = "ipam-${var.environment}"
}

resource "aws_ram_principal_association" "principal" {
    principal          = data.aws_ssm_parameter.ous.value
    resource_share_arn = aws_ram_resource_share.ipam_pool.arn

  depends_on = [
    aws_ram_resource_share.ipam_pool
  ]
}

resource "aws_ram_resource_association" "ipam_association" {
  resource_arn       = aws_vpc_ipam_pool.child_pool.arn
  resource_share_arn = aws_ram_resource_share.ipam_pool.arn
}
