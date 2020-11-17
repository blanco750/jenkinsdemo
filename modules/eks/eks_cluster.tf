# Retrieve information about an EKS Cluster
data "aws_eks_cluster" "cluster" {
    name = aws_eks_cluster.fuseEKScluster.id
}

# Get an authentication token to communicate with an EKS cluster.
data "aws_eks_cluster_auth" "cluster" {
    name = aws_eks_cluster.fuseEKScluster.id
}

resource "aws_eks_cluster" "fuseEKScluster" {
    name     = "${var.eksstackname}-${var.environment}"
    role_arn = aws_iam_role.eks_cluster_role.arn

    enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

    vpc_config {
    subnet_ids = concat(var.public_subnets.*.id, var.private_subnets.*.id)
    }

    timeouts {
    delete = "30m"
    }


    tags = {
    Name                                                   = "${var.eksstackname}-${var.environment}-eks"
    Environment                                            = var.environment
    }
    depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
    ]
}

# Create the kubeconfig file
data "template_file" "kubeconfig" {
    template = file("${path.module}/templates/kubeconfig.tpl")

    vars = {
    kubeconfig_name           = "eks_${aws_eks_cluster.fuseEKScluster.name}"
    clustername               = aws_eks_cluster.fuseEKScluster.name
    endpoint                  = data.aws_eks_cluster.cluster.endpoint
    cluster_auth_base64       = data.aws_eks_cluster.cluster.certificate_authority[0].data
    }
}

resource "local_file" "kubeconfig" {
    content  = data.template_file.kubeconfig.rendered
    filename = pathexpand("${var.kubeconfig_path}/config")
}