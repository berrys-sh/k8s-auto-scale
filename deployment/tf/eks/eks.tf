####################################################################
#
# Creates the EKS Cluster control plane
#
####################################################################

data "aws_iam_policy_document" "assume_role_eks" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_eks_cluster" "demo_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn # Updated to use the new role

  vpc_config {
    subnet_ids              = aws_subnet.public[*].id
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [aws_security_group.eks_cluster.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
  ]
}
resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

resource "aws_security_group_rule" "eks_cluster_ingress_workstation_https" {
  cidr_blocks       = ["0.0.0.0/0"] # You might want to restrict this to your IP or VPN range
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 0
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_cluster.id
  to_port           = 65535
  type              = "ingress"
}

# Output the endpoint for the EKS cluster
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.demo_eks.endpoint
}

# Output the security group ID for the EKS cluster
output "eks_cluster_security_group_id" {
  value = aws_security_group.eks_cluster.id
}

# IAM policy for EKS nodes to access ECR
resource "aws_iam_role_policy_attachment" "eks_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_cluster_role.name
}