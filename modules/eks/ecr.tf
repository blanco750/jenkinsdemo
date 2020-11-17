# resource "aws_ecr_repository" "fuse_ecr_repo" {
#     name                 = var.ecr_name

#     image_scanning_configuration {
#     scan_on_push = true
#     }
# }
# data "aws_caller_identity" "current" {}

# resource "null_resource" "dockerimagebuild" {

#     provisioner "local-exec" {
#         working_dir = "../../demoapp/"
#         command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
#     }

#     provisioner "local-exec" {
#         working_dir = "../../demoapp/"
#         command = "docker build -t ${aws_ecr_repository.fuse_ecr_repo.name} ."
#     }

#     provisioner "local-exec" {
#         working_dir = "../../demoapp/"
#         command = "docker tag ${aws_ecr_repository.fuse_ecr_repo.name}:latest ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.fuse_ecr_repo.name}:latest"
#     }

#     provisioner "local-exec" {
#         working_dir = "../../demoapp/"
#         command = "docker push ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.fuse_ecr_repo.name}:latest"
#     }

#     depends_on = [aws_ecr_repository.fuse_ecr_repo]
#     }