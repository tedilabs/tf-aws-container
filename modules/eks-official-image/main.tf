locals {
  metadata = {
    package = "terraform-aws-container"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = "${var.kubernetes_version}/${var.os.name}/${var.os.release}/${var.arch}"
  }
}

locals {
  # INFO: Not support amazon-linux-2-gpu
  amazon_linux = {
    types = {
      "2/amd64"    = "amazon-linux-2"
      "2/arm64"    = "amazon-linux-2-arm64"
      "2023/amd64" = "amazon-linux-2023/x86_64/standard"
      "2023/arm64" = "amazon-linux-2023/arm64/standard"
    }
  }
  ubuntu = {
    prefixes = {
      "ubuntu"     = "/aws/service/canonical/ubuntu/eks"
      "ubuntu-pro" = "/aws/service/canonical/ubuntu/eks-pro"
    }
  }
  parameter_name = (var.os.name == "amazon-linux"
    ? join("/", [
      "/aws/service/eks/optimized-ami/${var.kubernetes_version}",
      local.amazon_linux.types["${var.os.release}/${var.arch}"],
      "recommended/image_id",
    ])
    : (contains(["ubuntu", "ubuntu-pro"], var.os.name)
      ? join("/", [
        local.ubuntu.prefixes[var.os.name],
        var.os.release,
        var.kubernetes_version,
        "stable/current",
        var.arch,
        "hvm/ebs-gp2/ami-id",
      ])
      : null
    )
  )
}


###################################################
# Official Image Data
###################################################

data "aws_ssm_parameter" "this" {
  name = local.parameter_name
}
