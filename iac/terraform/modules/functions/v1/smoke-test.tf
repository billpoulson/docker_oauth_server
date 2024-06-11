# Service
resource "kubernetes_service_v1" "function_a" {
  metadata {
    namespace = var.app_namespace
    name      = "function-a"
  }
  spec {
    port {
      port        = 80
      target_port = 8080
    }
    selector = {
      app = "function-a"
    }
  }
}

# Deployment
resource "kubernetes_deployment_v1" "function_a" {
  metadata {
    namespace = var.app_namespace
    name      = "function-a"
  }

  spec {
    replicas = 1
    strategy {
      type = "RollingUpdate"
    }
    selector {
      match_labels = {
        app = "function-a"
      }
    }

    template {
      metadata {
        labels = {
          app = "function-a"
        }
      }

      spec {
        container {
          name              = "function-a"
          image             = var.function_a_image_name
          image_pull_policy = "Never"
          port {
            container_port = 8080
          }
          env {
            name  = "PORT"
            value = "8080"
          }

        }
      }
    }
  }
}