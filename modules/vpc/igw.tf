resource "aws_internet_gateway" "eksfuse" {
  vpc_id = aws_vpc.eksfuse.id

  tags = {
    Name        = "${var.eksclustername}-igw"
    Environment = var.environment
    Stack       = var.eksstackname
  }
}