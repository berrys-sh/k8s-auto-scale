resource "time_sleep" "wait_for_cluster" {
  depends_on = [aws_eks_cluster.demo_eks]

  create_duration = "120s"
}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = <<EOT
    set -x
      aws eks update-kubeconfig --region us-east-1 --name ${aws_eks_cluster.demo_eks.name}
      sleep 15
      kubectl config current-context
      kubectl config use-context $(kubectl config current-context)
    EOT
  }

  depends_on = [
    aws_eks_cluster.demo_eks,
    time_sleep.wait_for_cluster
  ]
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

  provisioner "local-exec" {
    command = "kubectl config current-context"
  }

  depends_on = [aws_eks_cluster.demo_eks,
    null_resource.update_kubeconfig
  ]

}