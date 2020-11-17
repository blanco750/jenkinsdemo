resource "time_sleep" "wait1_10_seconds" {
  depends_on = [aws_eks_cluster.fuseEKScluster]

  create_duration = "10s"
}


resource "aws_eks_fargate_profile" "default" {
  depends_on             = [time_sleep.wait1_10_seconds]
  cluster_name           = aws_eks_cluster.fuseEKScluster.name
  fargate_profile_name   = "fp-default"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = var.private_subnets.*.id

  selector {
    namespace = "default"
  }

  selector {
    namespace = var.namespace
  }

  selector {
    namespace = "kube-system"
  }

  timeouts {
    create = "30m"
    delete = "60m"
  }
}

resource "time_sleep" "wait2_20_seconds" {
  depends_on = [null_resource.updatekubeconfig]

  create_duration = "20s"
}


resource "time_sleep" "wait3_10_seconds" {
  depends_on = [null_resource.coredns_patch]

  create_duration = "10s"
}


# Coredns patching

resource "null_resource" "coredns_patch" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
kubectl  \
  patch deployment coredns \
  --namespace kube-system \
  --type=json \
  -p='[{"op": "remove", "path": "/spec/template/metadata/annotations", "value": "eks.amazonaws.com/compute-type"}]'
EOF
  }
  depends_on = [time_sleep.wait2_20_seconds]
}