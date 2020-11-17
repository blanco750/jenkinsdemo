resource "aws_eks_fargate_profile" "default" {
    cluster_name           = aws_eks_cluster.fuseEKScluster.name
    fargate_profile_name   = "fp-default"
    pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
    subnet_ids             = var.private_subnets.*.id

    selector {
    namespace = "default"
    }

    selector {
    namespace = "demoapp"
    }

    selector {
    namespace = "kube-system"
    }

    timeouts {
    create = "30m"
    delete = "60m"
    }
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [aws_eks_fargate_profile.default]

  create_duration = "60s"
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    aws_eks_fargate_profile.default,time_sleep.wait_60_seconds
  ]
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
  depends_on = [time_sleep.wait_60_seconds]
}