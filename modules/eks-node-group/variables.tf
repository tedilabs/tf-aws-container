variable "name" {
  description = "(Required) Name of node group to create."
  type        = string
}

variable "cluster_name" {
  description = "(Required) Name of the EKS cluster."
  type        = string
}


###################################################
# Auto Scaling Group
###################################################

variable "min_size" {
  description = "(Required) The minimum number of instances to run in the EKS cluster node group."
  type        = number
}

variable "max_size" {
  description = "(Required) The maximum number of instances to run in the EKS cluster node group."
  type        = number
}

variable "desired_size" {
  description = "(Optional) The number of instances that should be running in the group."
  type        = number
  default     = null
}

variable "subnet_ids" {
  description = "(Required) A list of subnets to place the EKS cluster node group within."
  type        = list(string)
}

variable "target_group_arns" {
  description = "(Optional) A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "force_delete" {
  description = "(Optional) Allows deleting the autoscaling group without waiting for all instances in the pool to terminate."
  type        = bool
  default     = false
  nullable    = false
}

variable "enabled_metrics" {
  description = "(Optional) A list of metrics to collect. The allowed values are GroupDesiredCapacity, GroupInServiceCapacity, GroupPendingCapacity, GroupMinSize, GroupMaxSize, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupStandbyCapacity, GroupTerminatingCapacity, GroupTerminatingInstances, GroupTotalCapacity, GroupTotalInstances."
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
  ]
  nullable = false
}


###################################################
# Launch Template
###################################################

variable "instance_ami" {
  description = "(Required) The AMI to run on each instance in the EKS cluster node group."
  type        = string
  nullable    = false
}

variable "instance_type" {
  description = "(Required) The type of instances to run in the EKS cluster node group."
  type        = string
  nullable    = false
}

variable "instance_ssh_key" {
  description = "(Required) The name of the SSH Key that should be used to access the each nodes."
  type        = string
  nullable    = false
}

variable "instance_profile" {
  description = "(Required) The name attribute of the IAM instance profile to associate with launched instances."
  type        = string
  nullable    = false
}

variable "root_volume_type" {
  description = "(Optional) The volume type for root volume. Can be standard, `gp2`, `gp3`, `io1`, `io2`, `sc1` or `st1`."
  type        = string
  default     = "gp2"
  nullable    = false
}

variable "root_volume_size" {
  description = "(Optional) The size of the root volume in gigabytes."
  type        = number
  default     = 20
  nullable    = false
}

variable "root_volume_iops" {
  description = "(Optional) The amount of provisioned IOPS for the root volume."
  type        = number
  default     = null
}

variable "root_volume_throughput" {
  description = "(Optional) The throughput to provision for a gp3 volume in MiB/s (specified as an integer, e.g. 500), with a maximum of 1,000 MiB/s."
  type        = number
  default     = null
}

variable "root_volume_encryption_enabled" {
  description = "(Optional) Enables EBS encryption on the root volume."
  type        = bool
  default     = false
  nullable    = false
}

variable "root_volume_encryption_kms_key_id" {
  description = "(Optional) The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use when creating the encrypted volume. `root_volume_encryption_enabled` must be set to true when this is set."
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "(Optional) If true, the launched EC2 instance will be EBS-optimized."
  type        = bool
  default     = false
  nullable    = false
}

variable "default_security_group" {
  description = <<EOF
  (Optional) The configuration of the default security group for the EKS node gorup. `default_security_group` block as defined below.
    (Optional) `enabled` - Whether to use the default security group. Defaults to `true`.
    (Optional) `name` - The name of the default security group. If not provided, the node group name is used for the name of security group.
    (Optional) `description` - The description of the default security group.
    (Optional) `ingress_rules` - A list of ingress rules in a security group.
    (Optional) `egress_rules` - A list of egress rules in a security group.
  EOF
  type = object({
    enabled       = optional(bool, true)
    name          = optional(string, null)
    description   = optional(string, "Managed by Terraform.")
    ingress_rules = optional(any, [])
    egress_rules  = optional(any, [])
  })
  default  = {}
  nullable = false
}

variable "security_groups" {
  description = "(Required) A list of security group IDs to assign to the node group."
  type        = list(string)
  nullable    = false
}

variable "associate_public_ip_address" {
  description = "(Optional) Associate a public ip address with an instance in a VPC."
  type        = bool
  default     = false
  nullable    = false
}

variable "monitoring_enabled" {
  description = "(Optional) If true, the launched EC2 instance will have detailed monitoring enabled."
  type        = bool
  default     = false
  nullable    = false
}

variable "node_labels" {
  description = "(Optional) A map of labels to add to the EKS cluster node group."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "node_taints" {
  description = "(Optional) A list of taints to add to the EKS cluster node group."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "bootstrap_extra_args" {
  description = "(Optional) Extra arguments to add to the `/etc/eks/bootstrap.sh`."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "kubelet_extra_args" {
  description = "(Optional) Extra arguments to add to the kubelet. Useful for adding labels or taints."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "cni_custom_networking_enabled" {
  description = "(Optional) Whether to use EKS CNI Custom Networking."
  type        = bool
  default     = false
  nullable    = false
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "(Optional) Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
  nullable    = false
}

variable "resource_group_name" {
  description = "(Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
  nullable    = false
}

variable "resource_group_description" {
  description = "(Optional) The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}
