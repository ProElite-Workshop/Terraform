resource "aws_vpc" "tuebora" {
  cidr_block       = "${lookup(var.cidr_ab, var.environment)}.${var.cidr_range}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${lower(var.TenantName)}-${lower(var.environment)}"
    Type = "customer"
  }

}