# variable "profile_name" {

# }

variable "eksstackname" {
  description = "the name of eks stack"
}

variable "environment" {
  description = "the name of environmnet e.g. dev"
}

variable "availability_zones" {
  description = "List of AZs"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "private_subnets" {
  description = "Private subnets CIDR"
}

variable "public_subnets" {
  description = "Public subnets CIDR"
}