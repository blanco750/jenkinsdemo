resource "aws_vpc" "eksfuse" {
    cidr_block           = var.cidr
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
    Name                                                   = "${var.eksstackname}-${var.environment}-vpc"
    Environment                                            = var.environment
    "kubernetes.io/cluster/${var.eksstackname}-${var.environment}" = "shared"
    }
}