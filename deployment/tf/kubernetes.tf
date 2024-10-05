provider "kubernetes" {
  config_path = "~/.kube/config"
  depends_on  = [null_resource.update_kubeconfig]
}

resource "time_sleep" "wait_for_cluster" {
  depends_on = [aws_eks_cluster.demo_eks]

  create_duration = "120s"
}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region us-east-1 --name ${aws_eks_cluster.demo_eks.name} && sleep 15"
  }

  depends_on = [aws_eks_cluster.demo_eks, time_sleep.wait_for_cluster]
}


resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.node_instance_role.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
EOF
  }

  depends_on = [aws_eks_cluster.demo_eks,
    null_resource.update_kubeconfig
  ]
}