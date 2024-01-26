resource "aws_efs_file_system" "eks" {
  creation_token = "eks-${lower(var.TenantName)}-${lower(var.environment)}"

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true

  # lifecycle_policy {
  #   transition_to_ia = "AFTER_30_DAYS"
  # }

  tags = {
    Name = "eks-${lower(var.TenantName)}-${lower(var.environment)}"
  }
}

resource "aws_efs_mount_target" "zone-a" {
  file_system_id  = aws_efs_file_system.eks.id
  subnet_id       = aws_subnet.private[0].id
  security_groups = [aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id]
}

