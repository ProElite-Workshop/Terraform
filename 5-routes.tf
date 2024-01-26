
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.tuebora.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tuebora.id
    }
    tags = {

        Name = "${lower(var.TenantName)}-${lower(var.environment)}-Public-RT"
    }
  
    depends_on = [ aws_internet_gateway.tuebora , aws_vpc.tuebora , aws_subnet.public ]
}
resource "aws_route_table" "private" {

    vpc_id = aws_vpc.tuebora.id
    route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  
    tags = {
        Name = "${lower(var.TenantName)}-${lower(var.environment)}-Private-RT"
    }
    depends_on = [ aws_internet_gateway.tuebora , aws_vpc.tuebora , aws_subnet.private ]

}



resource "aws_route_table_association" "private" {

    count          = "${length(local.private_subnets)}"
    subnet_id      = element(aws_subnet.private.*.id , count.index)
    route_table_id = aws_route_table.private.id
depends_on = [ aws_route_table.private ]
}
resource "aws_route_table_association" "public" {

    count          = "${length(local.public_subnets)}"
    subnet_id      = element(aws_subnet.public.*.id , count.index)
    route_table_id = aws_route_table.public.id
depends_on = [ aws_route_table.public ]
}

resource "aws_security_group" "public" {
  name = "${var.TenantName}-${var.environment}-public-sg"
  description = "Public internet access"
  vpc_id = aws_vpc.tuebora.id
 
  tags = {
    Name        = "${lower(var.TenantName)}-${lower(var.environment)}-public-sg"
    Role        = "public"
    Project     = "cloudcasts.io"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
  depends_on = [ aws_vpc.tuebora ]
}
resource "aws_security_group_rule" "public_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.public.id
  depends_on = [ aws_security_group.public ]
}
 
resource "aws_security_group_rule" "public_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
  depends_on = [ aws_security_group.public ]
}
 
resource "aws_security_group_rule" "public_in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
  depends_on = [ aws_security_group.public ]
}

resource "aws_security_group_rule" "public_in_rds" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
  depends_on = [ aws_security_group.public ]
}