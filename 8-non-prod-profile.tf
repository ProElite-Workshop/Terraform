resource "aws_eks_fargate_profile" "Non-Prod" {
  count = var.environment == "Non-Prod" ? 1 : 0
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = "${lower(var.TenantName)}-${lower(var.environment)}"
  pod_execution_role_arn = aws_iam_role.eks-fargate-profile.arn
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
 selector {
    namespace = "dev"
  }

  selector {
    namespace = "qa"
  }
}
# CloudWatch Metric Alarm for EKS Fargate CPU Utilization
resource "aws_cloudwatch_log_group" "eks_log_group_Non-Prod" {
  count               = var.environment == "Non-Prod" ? 1 : 0
  name = "/aws/eks/eks-${lower(var.TenantName)}-${lower(var.environment)}-fargate-metrics"
  retention_in_days = 7  # Adjust retention as needed
  depends_on = [ aws_eks_fargate_profile.Non-Prod[0] ]
  
}


resource "aws_cloudwatch_metric_alarm" "eks_fargate_cpu_alarm_Non-Prod" {
  count               = var.environment == "Non-Prod" ? 1 : 0
  alarm_name          = "eks-fargate-${lower(var.TenantName)}-${lower(var.environment)}-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EKS"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  actions_enabled     = true
  alarm_description   = "Alarm when EKS Fargate CPU Utilization exceeds 90%"

  dimensions = {
    ClusterName       = aws_eks_cluster.cluster.name
    FargateProfile    = aws_eks_fargate_profile.Non-Prod[count.index].fargate_profile_name
  }

  treat_missing_data = "notBreaching"
  depends_on = [ aws_eks_fargate_profile.Non-Prod[0]]
}
