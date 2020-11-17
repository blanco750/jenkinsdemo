resource "aws_internet_gateway" "eksfuse" {
    vpc_id = aws_vpc.eksfuse.id

    tags = {
    Name        = "${var.eksstackname}-${var.environment}-igw"
    Environment = var.environment
    }
}