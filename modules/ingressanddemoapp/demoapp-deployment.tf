# resource "kubernetes_deployment" "demoapp" {
#     metadata {
#         name      = "demoapp"
#         namespace = "demoapp"
#         labels    = {
#         app = "demoapp"
#         }
#     }

#     spec {
#         replicas = 3

#         selector {
#         match_labels = {
#             app = "demoapp"
#         }
#         }

#         strategy {
#             type = "RollingUpdate"
#             rolling_update {
#                 max_unavailable = "1"
#             }
#         }

#         template {
#         metadata {
#             labels = {
#             app = "demoapp"
#             }
#         }

#         spec {
#             container {
#             image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_name}:latest"
#             name  = "demoapp"

#             port {
#                 container_port = 80
#             }
#             }
#         }
#     }
# }

#     depends_on = [null_resource.dependency_getter, kubernetes_namespace.demoapp]
# }

# resource "null_resource" "dependency_getter" {
#     provisioner "local-exec" {
#     command = "echo ${length(var.dependencies)}"
#     }
# }