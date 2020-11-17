resource "aws_vpc" "eksfuse" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                                                             = "${var.eksclustername}-vpc"
    Environment                                                      = var.environment
    Stack                                                            = var.eksstackname
    "kubernetes.io/cluster/${var.eksclustername}-${var.environment}" = "shared"
  }
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/fuse/VPC_ID"
  type  = "String"
  value = aws_vpc.eksfuse.id
  overwrite = true
}