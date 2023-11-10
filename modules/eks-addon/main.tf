locals {
  metadata = {
    package = "terraform-aws-container"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}


###################################################
# EKS Addon
###################################################

resource "aws_eks_addon" "this" {
  cluster_name = var.cluster_name

  addon_name    = var.name
  addon_version = var.addon_version

  configuration_values = var.configuration

  service_account_role_arn = var.service_account_role

  resolve_conflicts_on_create = var.conflict_resolution_strategy_on_create
  resolve_conflicts_on_update = var.conflict_resolution_strategy_on_update
  preserve                    = var.preserve_on_delete

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  tags = merge(
    {
      "Name" = var.name
    },
    local.module_tags,
    var.tags,
  )
}
