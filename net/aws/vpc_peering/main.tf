// file: net/aws/vpc_peering/main.tf

// ---------------------------------------------------------------------------------------------------------------------
// Variables
// ---------------------------------------------------------------------------------------------------------------------

variable "vpc_id" {
  description = "ID of the primary VPC"
}

variable "peer_vpc_id" {
  description = "ID of the peer VPC"
}

variable "name" {
  description = "Name tag (e.g. cloud)"
  default     = "stack"
}

// ---------------------------------------------------------------------------------------------------------------------
// Resources
// ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc_peering_connection" "main" {
  vpc_id      = "${var.vpc_id}"
  peer_vpc_id = "${var.peer_vpc_id}"
  auto_accept = true

  tags {
    Name = "${var.name}"
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------------------------------------------------

output "id"            { value = "${aws_vpc_peering_connection.main.id}" }
output "accept_status" { value = "${aws_vpc_peering_connection.main.accept_status}" }
