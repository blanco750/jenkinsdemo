# resource "kubernetes_service" "nginx-service" {
#     metadata {
#     name      = "nginx-service"
#     namespace = "demoapp"
#     }
#     spec {
#         selector = {
#             app = "demoapp"
#     }

#         port {
#         port        = 80
#         target_port = 80
#         protocol    = "TCP"
#         }

#         type = "NodePort"
#         }

#         depends_on = [kubernetes_deployment.demoapp]
# }