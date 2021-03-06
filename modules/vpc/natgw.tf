resource "aws_nat_gateway" "eksfuse" {
    count         = length(var.private_subnets)
    allocation_id = element(aws_eip.nat.*.id, count.index)
    subnet_id     = element(aws_subnet.public.*.id, count.index)
    depends_on    = [aws_internet_gateway.eksfuse]

    tags = {
    Name        = "${var.eksstackname}-${var.environment}-nat-${format("%03d", count.index+1)}"
    Environment = var.environment
    }
}

resource "aws_eip" "nat" {
    count = length(var.private_subnets)
    vpc = true

    tags = {
    Name        = "${var.eksstackname}-${var.environment}-eip-${format("%03d", count.index+1)}"
    Environment = var.environment
    }
}