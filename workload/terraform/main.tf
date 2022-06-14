locals {
    subnets = cidrsubnets(aws_vpc.vpc.cidr_block, 2, 2, 2, 2)
}

resource "aws_vpc" "vpc" {
   ipv4_ipam_pool_id   = data.aws_vpc_ipam_pool.ipam_pool.id
   ipv4_netmask_length = 26
   enable_dns_hostnames = true
}

resource "aws_subnet" "endpoint_subnet" {
    count = 2
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = local.subnets[count.index]
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

    tags = {
      "Name" = "endpoint-subnet-${data.aws_availability_zones.available.names[count.index]}"
    }
}

resource "aws_subnet" "application_subnets" {
    count = 2
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = local.subnets[count.index + 2 ]
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
    map_public_ip_on_launch = true

    tags = {
      "Name" = "application-subnet-${data.aws_availability_zones.available.names[count.index]}"
    }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "attach_tgw" {
  subnet_ids         = [aws_subnet.endpoint_subnet[0].id, aws_subnet.endpoint_subnet[1].id]
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc.id
}

resource "aws_route" "internal_subnets_route" {
  #Add route for all non-local traffic to traverse toward the Transit Gateway
  route_table_id            = aws_vpc.vpc.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
}
