# variable "profile_name" {
# }

variable "eksstackname" {
  description = "the name of eks stack"
  default     = "fuseterraform-eks"
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
  default     = "192.168.0.0/16"
}

variable "private_subnets" {
  description = "Private subnets CIDR"
  default     = ["192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20"]
}

variable "public_subnets" {
  description = "Public subnets CIDR"
  default     = ["192.168.48.0/20", "192.168.64.0/20", "192.168.80.0/20"]
}

variable "kubeconfig_path" {
  description = "path of the kube config file to be used by kubectl"
  default     = "~/.kube"
}

variable "ecr_name" {
  description = "name of the ecr repo"
  default     = "fuse-eks-ecr"
}