output "vpcid" {
  value = aws_vpc.eksfuse.id
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}