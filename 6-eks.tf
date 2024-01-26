resource "aws_iam_role" "eks-cluster" {
  name = "${lower(var.TenantName)}-${lower(var.environment)}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
#Attach the necessary policies to the IAM role for EKS Cluster Policy
resource "aws_iam_role_policy_attachment" "amazon-eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

# Attach the necessary policies to the IAM role for EKS to CloudWatch integration
resource "aws_iam_role_policy_attachment" "eks_cloudwatch_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
   role       = aws_iam_role.eks-cluster.name
}

resource "aws_eks_cluster" "cluster" {
  name     = "${lower(var.TenantName)}-${lower(var.environment)}"
  version  = var.cluster_version
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {

    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

    subnet_ids = [for subnet in aws_subnet.private : subnet.id]
  }

  depends_on = [aws_iam_role_policy_attachment.amazon-eks-cluster-policy]
}
