# resource "kubernetes_ingress" "nginx-ingress" {
#     metadata {
#         name      = "nginx-ingress"
#         namespace = "demoapp"
#         annotations = {
#             "kubernetes.io/ingress.class"           = "alb"
#             "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
#             "alb.ingress.kubernetes.io/target-type" = "ip"
#         }
#         labels = {
#             "app" = "nginx-ingress"
#         }
#     }

#     spec {
#         rule {
#         http {
#             path {
#             path = "/*"
#             backend {
#                 service_name = "nginx-service"
#                 service_port = 80
#             }
#             }
#         }
#         }
#     }

#     depends_on = [kubernetes_service.nginx-service]
# }