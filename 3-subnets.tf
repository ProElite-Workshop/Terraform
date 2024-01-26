resource "aws_subnet" "private" {
  count                   = "${length(local.private_subnets)}"
  vpc_id                  = "${aws_vpc.tuebora.id}"
  cidr_block              = "${local.private_subnets[count.index]}"
  availability_zone     = "${data.aws_availability_zones.available.names[count.index]}"

  map_public_ip_on_launch = false
  tags = {
    Name = "${lower(var.TenantName)}-${lower(var.environment)}-private-${data.aws_availability_zones.available.names[count.index]}"
    Tier = "Private"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.TenantName}" = "owned"
  }
  depends_on = [ aws_vpc.tuebora ]
}

resource "aws_subnet" "public" {
  count                   = "${length(local.public_subnets)}"
  vpc_id                  = "${aws_vpc.tuebora.id}"
  cidr_block              = "${local.public_subnets[count.index]}"
  availability_zone      = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${lower(var.TenantName)}-${lower(var.environment)}-public-${data.aws_availability_zones.available.names[count.index]}"
    Tier = "Public"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.TenantName}" = "owned"
  }
  depends_on = [ aws_vpc.tuebora ]
}