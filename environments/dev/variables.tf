# variable "profile_name" {
# }

variable "eksclustername" {
  description = "the name of eks cluster"
  default     = "fuseterraform-am-eksfargate"
}

variable "namespace" {
  description = "the name of eks cluster namespace where app will be deployed"
  default     = "audience-management"
}

variable "app" {
  description = "the name of app the will be deployed"
  default     = "audience-management"
}


variable "eksstackname" {
  description = "the name of eks stack"
  default     = "dev-dublin"
}

variable "environment" {
  description = "the name of environmnet e.g. dev"
  default     = "dev"
}

variable "region" {
  description = "The aws region in which cluster and related resources are created, you must set the AZ variable as well if you change this value from default value"
  default     = "eu-west-1"
}

variable "availability_zones" {
  description = "List of AZs"
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.50.0.0/16"
}

variable "private_subnets" {
  description = "Private subnets CIDR"
  default     = ["10.50.0.0/20", "10.50.16.0/20", "10.50.32.0/20"]
}

variable "public_subnets" {
  description = "Public subnets CIDR"
  default     = ["10.50.48.0/20", "10.50.64.0/20", "10.50.80.0/20"]
}

variable "kubeconfig_path" {
  description = "path of the kube config file to be used by kubectl"
  default     = "~/.kube"
}

variable "ecr_name" {
  description = "name of the ecr repo"
  default     = "fuse-eks-ecr"
}

variable "es_sg" {
  description = "Name of ES security group"
  default     = "am-es"
}

variable "es_domain_name" {
  description = "Name of ES domain"
  default     = "am-es"
}

variable "instance_type" {
  description = "ES instance type"
  default     = "t2.medium.elasticsearch"
}