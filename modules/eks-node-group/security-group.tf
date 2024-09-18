data "aws_subnet" "this" {
  id = var.subnet_ids[0]
}

locals {
  vpc_id = data.aws_subnet.this.vpc_id
  security_groups = (var.default_security_group.enabled
    ? concat(module.security_group[*].id, var.security_groups)
    : var.security_groups
  )
}


###################################################
# Security Group
###################################################

module "security_group" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "~> 0.32.1"

  count = var.default_security_group.enabled ? 1 : 0

  name        = coalesce(var.default_security_group.name, local.metadata.name)
  description = var.default_security_group.description
  vpc_id      = local.vpc_id

  ingress_rules = [
    for i, rule in var.default_security_group.ingress_rules :
    merge(rule, {
      id = coalesce(rule.id, "eks-node-group-${i}")
    })
  ]
  egress_rules = [
    for i, rule in var.default_security_group.egress_rules :
    merge(rule, {
      id = coalesce(rule.id, "eks-node-group-${i}")
    })
  ]

  revoke_rules_on_delete = true
  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
