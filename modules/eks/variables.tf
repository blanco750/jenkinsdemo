# variable "profile_name" {
# }

variable "eksstackname" {
  description = "the name of eks stack"
}

variable "environment" {
  description = "the name of environmnet e.g. dev"
}

variable "region" {
  description = "The AWS region in which EKS cluster and remaining resources are created"
}

variable "kubeconfig_path" {
  description = "path of the kube config file to be used by kubectl"
}

variable "vpc_id" {
  description = "The VPC the EKS cluser will be created in"
}

variable "private_subnets" {
  description = "List of private subnet IDs"
}

variable "public_subnets" {
  description = "List of Public subnet IDs"
}

variable "ecr_name" {
  description = "name of the ecr repo"
}


variable "dependencies" {
  type    = list
  default = []
}