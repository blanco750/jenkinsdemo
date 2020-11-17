variable "eksstackname" {
    description = "the name of EKS cluster stack"
}

variable "environment" {
    description = "the name of your environment"
}

variable "region" {
    description = "The AWS region in which EKS resources are created"
}

variable "vpc_id" {
    description = "The VPC of the EKS cluser"
}

variable "cluster_id" {
    description = "The ID of the cluster where the ingress controller should be attached"
}

variable "ecr_name" {
    description = "name of the ecr repo"
}

variable "dependencies" {
    type    = list
    default = []
}