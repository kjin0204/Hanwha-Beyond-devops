# # Kubernetes 프로바이더 설정
# provider "kubernetes" {
#   config_path = "~/.kube/config"  # 로컬 Kubernetes 설정 파일 경로
# }

# # Spring Boot Deployment
# resource "kubernetes_deployment" "boot002dep" {
#   metadata {
#     name = "boot002dep"
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "boot002kube"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "boot002kube"
#         }
#       }

#       spec {
#         container {
#           image = "ys0915/k8s_19_boot:latest"
#           name  = "boot-container"
#           image_pull_policy = "Always"

#           port {
#             container_port = 7777
#           }
#         }
#       }
#     }
#   }
# }

# # Spring Boot Service
# resource "kubernetes_service" "boot002ser" {
#   metadata {
#     name = "boot002ser"
#   }

#   spec {
#     selector = {
#       app = "boot002kube"
#     }

#     port {
#       port        = 8001
#       target_port = 7777
#     }

#     type = "ClusterIP"
#   }
# }

# # Vue.js Deployment
# resource "kubernetes_deployment" "vue002dep" {
#   metadata {
#     name = "vue002dep"
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "vue002kube"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "vue002kube"
#         }
#       }

#       spec {
#         container {
#           image = "ys0915/k8s_19_vue:latest"
#           name  = "vue-container"
#           image_pull_policy = "Always"

#           port {
#             container_port = 80
#           }
#         }
#       }
#     }
#   }
# }

# # Vue.js Service
# resource "kubernetes_service" "vue002ser" {
#   metadata {
#     name = "vue002ser"
#   }

#   spec {
#     selector = {
#       app = "vue002kube"
#     }

#     port {
#       port        = 8000
#       target_port = 80
#     }

#     type = "ClusterIP"
#   }
# }

# # Ingress
# resource "kubernetes_ingress_v1" "sw_camp_ingress" {
#   metadata {
#     name = "sw-camp-ingress"
#     annotations = {
#       "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
#       "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
#     }
#   }

#   spec {
#     ingress_class_name = "nginx"

#     rule {
#       http {
#         path {
#           path = "/()(.*)$"
#           path_type = "ImplementationSpecific"
#           backend {
#             service {
#               name = "vue002ser"
#               port {
#                 number = 8000
#               }
#             }
#           }
#         }
#         path {
#           path = "/boot(/|$)(.*)$"
#           path_type = "ImplementationSpecific"
#           backend {
#             service {
#               name = "boot002ser"
#               port {
#                 number = 8001
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }