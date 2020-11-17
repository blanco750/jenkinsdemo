module "vpc" {
  source             = "../../modules/vpc"
  eksclustername     = var.eksclustername
  eksstackname       = var.eksstackname
  environment        = var.environment
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
}

module "eks" {
  source          = "../../modules/eks"
  eksclustername  = var.eksclustername
  eksstackname    = var.eksstackname
  namespace       = var.namespace
  app             = var.app
  environment     = var.environment
  region          = var.region
  vpc_id          = module.vpc.vpcid
  cidr            = var.cidr
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  kubeconfig_path = var.kubeconfig_path
  ecr_name        = var.ecr_name
  es_sg           = var.es_sg
  es_domain_name= var.es_domain_name
  instance_type = var.instance_type

}

# module "ingressanddemoapp" {
#     source       = "../../modules/ingressanddemoapp"
#     eksclustername = var.eksclustername
#     eksstackname         = var.eksstackname
#     environment  = var.environment
#     region       = var.region
#     vpc_id       = module.vpc.vpcid
#     cluster_id   = module.eks.cluster_id
#     ecr_name = var.ecr_name
# }
