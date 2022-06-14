module "tgw" {
    source = "./modules/tgw"
    for_each = var.environments
        environment = each.key
        ous = var.ous[each.key]
}

module "ipam" {
    source = "./modules/ipam"
    for_each = var.environments
        environment = each.key
        ous = var.ous[each.key]
}
