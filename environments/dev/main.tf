module "vpc" {
    source             = "../../modules/vpc"
    eksstackname               = var.eksstackname
    environment        = var.environment
    cidr               = var.cidr
    private_subnets    = var.private_subnets
    public_subnets     = var.public_subnets
    availability_zones = var.availability_zones
}

module "eks" {
    source          = "../../modules/eks"
    eksstackname            = var.eksstackname
    environment     = var.environment
    region          = var.region
    vpc_id          = module.vpc.vpcid
    private_subnets = module.vpc.private_subnets
    public_subnets  = module.vpc.public_subnets
    kubeconfig_path = var.kubeconfig_path
    ecr_name = var.ecr_name
    dependencies = [
    module.eks.depended_on
    ]
}

module "ingressanddemoapp" {
    source       = "../../modules/ingressanddemoapp"
    eksstackname         = var.eksstackname
    environment  = var.environment
    region       = var.region
    vpc_id       = module.vpc.vpcid
    cluster_id   = module.eks.cluster_id
    ecr_name = var.ecr_name
}
