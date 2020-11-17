# variable "profile_name" {
# }

variable "eksclustername" {
  description = "the name of eks cluster"
}

variable "namespace" {
  description = "the name of eks cluster namespace where app will be deployed"
}

variable "app" {
  description = "the name of app the will be deployed"
}

variable "eksstackname" {
  description = "the name of eks stack"
}

variable "environment" {
  description = "the name of environmnet e.g. dev"
}

variable "region" {
  description = "The aws region in which EKS cluster and remaining resources are created"
}

variable "kubeconfig_path" {
  description = "path of the kube config file to be used by kubectl"
}

variable "vpc_id" {
  description = "The VPC the EKS cluser will be created in"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
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

variable "es_sg" {
  description = "Name of ES security group"
}


variable "es_domain_name" {
  description = "Name of ES domain"
}

variable "instance_type" {
  description = "ES instance type"
}