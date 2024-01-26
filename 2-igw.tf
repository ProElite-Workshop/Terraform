resource "aws_internet_gateway" "tuebora" {
  vpc_id = aws_vpc.tuebora.id

  tags = {
    Name = "${lower(var.TenantName)}-${lower(var.environment)}-ig"
  }
}
