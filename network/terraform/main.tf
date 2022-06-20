module "tgw" {
    source = "./modules/tgw"
    for_each = var.environments
        environment = each.key
}

module "ipam" {
    source = "./modules/ipam"
    for_each = var.environments
        environment = each.key
}
