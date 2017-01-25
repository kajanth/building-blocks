// file: environment/aws/main.tf

variable "availability_zones" {
  type        = "list"
  description = "List of availability zones to use for creating network infrastructure"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "cidr_blocks" {
  type        = "map"
  description = "CIDR address blocks for the VPCs"
  default     = {
    "main"    = "10.10.0.0/16"
    "valinor" = "10.11.0.0/16"
  }
}

variable "internal_subnets" {
  type = "map"
  description = "Internal subnet definitions for each VPC"
  default = {
    "main"    = ""
    "valinor" = "10.11.128.0/20,10.11.134.0/20"
  }
}

variable "external_subnets" {
  type = "map"
  description = "External subnet definitions for each VPC"
  default = {
    "main"    = ""
    "valinor" = "10.11.32.0/20,10.11.48.0/20,10.11.64.0/20"
  }
}

variable "name" {
  description = "Name of the environment (e.g. 'myenv' or 'prod')"
}

module "main_vpc" {
  source             = "../../net/aws/vpc"
  name               = "${var.name}-main"
  availability_zones = ["${var.availability_zones}"]
  cidr_block         = "${lookup(var.cidr_blocks, "main")}"
  internal_subnets   = ["${split(",", lookup(var.internal_subnets, "main"))}"]
  external_subnets   = ["${split(",", lookup(var.external_subnets, "main"))}"]
}

module "valinor_vpc" {
  source             = "../../net/aws/vpc"
  name               = "${var.name}-valinor"
  availability_zones = ["${var.availability_zones}"]
  cidr_block         = "${lookup(var.cidr_blocks, "valinor")}"
  internal_subnets   = ["${split(",", lookup(var.internal_subnets, "valinor"))}"]
  external_subnets   = ["${split(",", lookup(var.external_subnets, "valinor"))}"]
}

module "main_to_valinor" {
  source      = "../../net/aws/vpc_peering"
  vpc_id      = "${module.main_vpc.id}"
  peer_vpc_id = "${module.valinor_vpc.id}"
}

// ---------------------------------------------------------------------------------------------------------------------
// Security Groups
// ---------------------------------------------------------------------------------------------------------------------

// Allow traffic FROM valinor INTO main
resource "aws_security_group_rule" "ingress_valinor_to_main" {
  security_group_id        = "${module.main_vpc.security_group}"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${module.valinor_vpc.security_group}"
}

// Allow traffic FROM main INTO VALINOR
resource "aws_security_group_rule" "ingress_main_to_valinor" {
  security_group_id        = "${module.valinor_vpc.security_group}"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${module.main_vpc.security_group}"
}

output "main_vpc_id"           { value = "${module.main_vpc.id}" }
output "main_internal_subnets" { value = "${module.main_vpc.internal_subnets}" }
output "main_external_subnets" { value = "${module.main_vpc.external_subnets}" }

output "valinor_vpc_id"           { value = "${module.valinor_vpc.id}" }
output "valinor_internal_subnets" { value = "${module.valinor_vpc.internal_subnets}" }
output "valinor_external_subnets" { value = "${module.valinor_vpc.external_subnets}" }