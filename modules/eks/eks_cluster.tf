# Retrieve information about an EKS Cluster
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.fuseEKScluster.id
}

# Get an authentication token to communicate with an EKS cluster.
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.fuseEKScluster.id
}

resource "aws_eks_cluster" "fuseEKScluster" {
  name     = "${var.eksclustername}-${var.environment}"
  role_arn = aws_iam_role.eks_cluster_role.arn

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids = concat(var.public_subnets.*.id, var.private_subnets.*.id)
  }

  timeouts {
    delete = "30m"
  }


  tags = {
    Name        = "${var.eksclustername}-${var.environment}"
    Environment = var.environment
    Stack       = var.eksstackname
    app         = var.app
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}

# Create the kubeconfig file

resource "null_resource" "updatekubeconfig" {
  depends_on = [aws_eks_fargate_profile.default]
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${var.eksclustername}-${var.environment}"
  }
}

#store the cluster name in Parameter store env variables to later be used by kubernetes operators

resource "aws_ssm_parameter" "cluster_name" {
  name  = "/fuse/CLUSTER_NAME"
  type  = "String"
  value = aws_eks_cluster.fuseEKScluster.name
  overwrite = true
}


resource "aws_ssm_parameter" "application_name" {
  name  = "/fuse/APPLICATION_NAME"
  type  = "String"
  value = var.app
  overwrite = true
}

#Config left here for future reference

# data "template_file" "kubeconfig" {
#     template = file("${path.module}/templates/kubeconfig.tpl")

#     vars = {
#     kubeconfig_name           = "eks_${aws_eks_cluster.fuseEKScluster.name}"
#     clustername               = aws_eks_cluster.fuseEKScluster.name
#     endpoint                  = data.aws_eks_cluster.cluster.endpoint
#     cluster_auth_base64       = data.aws_eks_cluster.cluster.certificate_authority[0].data
#     }
# }

# resource "local_file" "kubeconfig" {
#     content  = data.template_file.kubeconfig.rendered
#     filename = pathexpand("${var.kubeconfig_path}/config")
#}