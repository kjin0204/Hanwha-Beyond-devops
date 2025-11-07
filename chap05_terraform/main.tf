# Kubernetes 프로바이더 설정
provider "kubernetes" {
  config_path = "~/.kube/config"  # 로컬 Kubernetes 설정 파일 경로
}

# PersistentVolumeClaim - MariaDB 데이터 영속성 보장
# MariaDB 데이터 저장용 PVC
resource "kubernetes_persistent_volume_claim" "mariadb_data_pvc" {
  metadata {
    name = "mariadb-data-pvc"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    
    storage_class_name = "hostpath"
  }
}

# MariaDB 로그 저장용 PVC
resource "kubernetes_persistent_volume_claim" "mariadb_logs_pvc" {
  metadata {
    name = "mariadb-logs-pvc"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    
    resources {
      requests = {
        storage = "500Mi"
      }
    }
    
    storage_class_name = "hostpath"
  }
}

# MariaDB Deployment and Service
resource "kubernetes_deployment" "mariadb003dep" {
  metadata {
    name = "mariadb003dep"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mariadb003kube"
      }
    }

    template {
      metadata {
        labels = {
          app = "mariadb003kube"
        }
      }

      spec {
        container {
          image = "mariadb:latest"
          name  = "mariadb-container"

          env {
            name  = "MARIADB_ROOT_PASSWORD"
            value = "root1234"
          }

          env {
            name  = "MARIADB_DATABASE"
            value = "calcdb"
          }

          port {
            container_port = 3306
          }

          args = [
            "--log-error=/var/log/mysql/error.log",
            "--general-log=1",
            "--general-log-file=/var/log/mysql/general.log",
            "--slow-query-log=1",
            "--slow-query-log-file=/var/log/mysql/slow.log",
            "--long-query-time=2"
          ]

          volume_mount {
            name       = "mariadb-data"
            mount_path = "/var/lib/mysql"
          }

          volume_mount {
            name       = "mariadb-logs"
            mount_path = "/var/log/mysql"
          }

          liveness_probe {
            exec {
              command = ["healthcheck.sh", "--connect", "--innodb_initialized"]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 5
          }

          readiness_probe {
            exec {
              command = ["healthcheck.sh", "--connect", "--innodb_initialized"]
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 5
          }
        }

        volume {
          name = "mariadb-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mariadb_data_pvc.metadata[0].name
          }
        }

        volume {
          name = "mariadb-logs"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mariadb_logs_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mariadb003ser" {
  metadata {
    name = "mariadb003ser"
  }

  spec {
    selector = {
      app = "mariadb003kube"
    }

    port {
      port        = 3310
      target_port = 3306
    }

    type = "ClusterIP"
  }
}

# Spring Boot Deployment and Service
resource "kubernetes_deployment" "boot003dep" {
  metadata {
    name = "boot003dep"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "boot003kube"
      }
    }

    template {
      metadata {
        labels = {
          app = "boot003kube"
        }
      }

      spec {
        container {
          image             = "kang92/jen_19_boot2:latest"
          name              = "boot-container"
          image_pull_policy = "Always"

          port {
            container_port = 7777
          }

          env {
            name  = "SPRING_DATASOURCE_URL"
            value = "jdbc:mariadb://mariadb003ser:3310/calcdb"
          }

          env {
            name  = "SPRING_DATASOURCE_USERNAME"
            value = "root"
          }

          env {
            name  = "SPRING_DATASOURCE_PASSWORD"
            value = "root1234"
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 7777
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 7777
            }
            initial_delay_seconds = 60
            period_seconds        = 15
            timeout_seconds       = 5
            failure_threshold     = 3
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_deployment.mariadb003dep,
    kubernetes_service.mariadb003ser
  ]
}

resource "kubernetes_service" "boot003ser" {
  metadata {
    name = "boot003ser"
  }

  spec {
    selector = {
      app = "boot003kube"
    }

    port {
      port        = 8001
      target_port = 7777
    }

    type = "ClusterIP"
  }
}

# Vue.js Deployment and Service
resource "kubernetes_deployment" "vue003dep" {
  metadata {
    name = "vue003dep"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "vue003kube"
      }
    }

    template {
      metadata {
        labels = {
          app = "vue003kube"
        }
      }

      spec {
        container {
          image             = "kang92/jen_19_vue:latest"
          name              = "vue-container"
          image_pull_policy = "Always"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "vue003ser" {
  metadata {
    name = "vue003ser"
  }

  spec {
    selector = {
      app = "vue003kube"
    }

    port {
      port        = 8000
      target_port = 80
    }

    type = "ClusterIP"
  }
}

# Ingress
resource "kubernetes_ingress_v1" "sw_camp_ingress_db" {
  metadata {
    name = "sw-camp-ingress-db"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"  = "false"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path      = "/()(.*)$"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service.vue003ser.metadata[0].name
              port {
                number = 8000
              }
            }
          }
        }
        path {
          path      = "/boot(/|$)(.*)$"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service.boot003ser.metadata[0].name
              port {
                number = 8001
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.vue003ser,
    kubernetes_service.boot003ser
  ]
}
