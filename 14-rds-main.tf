resource "aws_db_subnet_group" "tuebora" {
  name       = "${lower(var.TenantName)}-${lower(var.environment)}-subnet-group"
  subnet_ids = [for subnet in aws_subnet.public : subnet.id]

  tags = {
    Name = "${lower(var.TenantName)}-${lower(var.environment)}-subnet-group"
  }
}
resource "aws_db_parameter_group" "tuebora" {
  name   = "${lower(var.TenantName)}-${lower(var.environment)}-parameter-group"
  family = "aurora-mysql5.7"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
parameter {
    name  = "group_concat_max_len"
    value = "16777216"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_rds_cluster" "tuebora" {
  
  cluster_identifier = "${lower(var.TenantName)}-${lower(var.environment)}"
  engine             = "aurora-mysql"
  engine_version     = var.engine_version
  //database_name      = var.db_name
  master_username    = var.username
  //master_password  = random_password.password.result
  master_password    = var.password
  skip_final_snapshot = "true"
  db_subnet_group_name = aws_db_subnet_group.tuebora.name
  storage_encrypted = "true"
  iam_database_authentication_enabled = "true"
  apply_immediately = true
  vpc_security_group_ids = [aws_security_group.public.id]
  depends_on = [ aws_db_subnet_group.tuebora ]
  
}

resource "aws_rds_cluster_instance" "tuebora" {
  count              = 2
  cluster_identifier = aws_rds_cluster.tuebora.cluster_identifier
  identifier         = "${lower(var.TenantName)}-${lower(var.environment)}-instance-${count.index}"
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.tuebora.engine
  db_parameter_group_name = aws_db_parameter_group.tuebora.name
  publicly_accessible = "true"
  engine_version     = var.engine_version
  db_subnet_group_name = aws_db_subnet_group.tuebora.name
  apply_immediately = true
  depends_on = [ aws_rds_cluster.tuebora , aws_db_parameter_group.tuebora ]
  
}
