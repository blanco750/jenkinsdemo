output "kubectl_config" {
    description = "Path to new kubectl config file"
    value       = pathexpand("${var.kubeconfig_path}/config")
}

output "cluster_id" {
    description = "ID of the created EKS cluster"
    value       = aws_eks_cluster.fuseEKScluster.id
}


output "ecr_repo_uri" {
    description = "ECR Repo URI"
    value = aws_ecr_repository.fuse_ecr_repo.repository_url
}

output "depended_on" {
    value = "${null_resource.dependency_setter.id}"
}