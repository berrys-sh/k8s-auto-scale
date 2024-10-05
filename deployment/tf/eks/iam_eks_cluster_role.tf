# Create the EKS Cluster Service Role

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = var.eks_cluster_role_name
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json

  tags = {
    Name = var.eks_cluster_role_name
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Optional: If you want to allow access to the Elastic Load Balancing API and the ability to create network interfaces
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

output "eks_cluster_role_arn" {
  description = "ARN of the EKS Cluster IAM Role"
  value       = aws_iam_role.eks_cluster_role.arn
}