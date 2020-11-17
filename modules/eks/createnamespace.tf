resource "kubernetes_namespace" "appnamespace" {
  metadata {
    labels = {
      app = var.app
    }


    name = var.namespace
  }
  depends_on = [
    aws_eks_fargate_profile.default
  ]
}


resource "aws_ssm_parameter" "namespace_name" {
  name  = "/fuse/NAMESPACE"
  type  = "String"
  value = var.namespace
  overwrite = true
  depends_on = [
    kubernetes_namespace.appnamespace
  ]
}