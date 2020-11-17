resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.eksfuse.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets)

  tags = {
    Name                                                             = "${var.eksclustername}-private-subnet-${format("%03d", count.index + 1)}",
    Environment                                                      = var.environment,
    "kubernetes.io/cluster/${var.eksclustername}-${var.environment}" = "shared"
    "kubernetes.io/role/internal-elb"                                = "1"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.eksfuse.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name                                                             = "${var.eksclustername}-public-subnet-${format("%03d", count.index + 1)}"
    Environment                                                      = var.environment
    Stack                                                            = var.eksstackname
    "kubernetes.io/cluster/${var.eksclustername}-${var.environment}" = "shared"
    "kubernetes.io/role/elb"                                         = "1"
  }
}