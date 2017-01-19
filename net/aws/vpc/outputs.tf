// file: vpc/outputs.tf

output "id"                 { value = "${aws_vpc.main.id}" }
output "external_subnets"   { value = ["${aws_subnet.external.*.id}"] }
output "internal_subnets"   { value = ["${aws_subnet.internal.*.id}"] }
output "security_group"     { value = "${aws_vpc.main.default_security_group_id}" }
output "availability_zones" { value = ["${aws_subnet.external.*.availability_zone}"] }
output "internal_rtb_id"    { value = "${join(",", aws_route_table.internal.*.id)}" }
output "external_rtb_id"    { value = "${aws_route_table.external.id}" }
output "internal_nat_ips"   { value = ["${aws_eip.nat.*.public_ip}"] }