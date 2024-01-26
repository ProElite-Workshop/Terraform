resource "aws_eip" "nat" {
  tags = {
    Name = "${lower(var.TenantName)}-${lower(var.environment)}-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${lower(var.TenantName)}-${lower(var.environment)}-nat"
  }

  depends_on = [aws_internet_gateway.tuebora]
}
