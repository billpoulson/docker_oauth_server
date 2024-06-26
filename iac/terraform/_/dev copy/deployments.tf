module "simple_oauth_deployment" {
  source = "../../modules/deployments"

  namespace               = var.namespace
  name                    = "simple-oauth"
  image                   = "porta-oauthx-v1"
  dot_env_secret          = var.dot_env_secret
  dot_env_key             = "oauth-service"
  default_volume_pvc_name = module.storage.default_volume_pvc_name
  container_port          = "8000"
}

resource "kubernetes_deployment_v1" "maint-site" {
  metadata {
    namespace = var.namespace
    name      = "maint-site"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "maint-site"
      }
    }
    template {
      metadata {
        labels = {
          app = "maint-site"
        }
      }
      spec {
        container {
          name  = "backend"
          image = "wickerlabs/maintenance:latest"
          port {
            container_port = 80
          }
          env {
            name  = "PORT"
            value = "80"
          }
          env {
            name  = "RESPONSE_CODE"
            value = "200"
          }
          env {
            name  = "THEME"
            value = "Dark"
          }
          env {
            name  = "TITLE"
            value = "Under maintenance"
          }
          env {
            name  = "HEADLINE"
            value = "We'll be right back,"
          }
          env {
            name  = "MESSAGE"
            value = "Sorry for the inconvenience but we're performing some maintenance at the moment. If you need to you can always {{contact}}, otherwise we'll be back online shortly!...."
          }
          env {
            name  = "TEAM_NAME"
            value = "Exhelion"
          }
          env {
            name  = "CONTACT_LINK"
            value = "Contact US"
          }
          env {
            name  = "MAIL_ADDRESS"
            value = "example@email.com"
          }
          # liveness_probe {
          #   exec {
          #     command = ["/bin/true"]
          #   }
          #   initial_delay_seconds = 3
          #   period_seconds        = 3
          # }

          # readiness_probe {
          #   exec {
          #     command = ["/bin/true"]
          #   }
          #   initial_delay_seconds = 3
          #   period_seconds        = 3
          # }
        }
      }
    }
  }
}

# Deployment
resource "kubernetes_deployment_v1" "oauth_manager" {
  metadata {
    namespace = var.namespace
    name      = "oauth-manager"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "oauth-manager"
      }
    }

    template {
      metadata {
        labels = {
          app = "oauth-manager"
        }
      }

      spec {
        container {
          name              = "oauth-manager"
          image             = "porta-oauthx-v1"
          image_pull_policy = "Never"
          port {
            container_port = 8000
          }
          env {
            name  = "PORT"
            value = "8000"
          }
          env {
            name  = "BASE_URL"
            value = "/manage"
          }
          env {
            name  = "API_URL"
            value = "/manage"
          }
          env {
            name = "DOTENV_KEY"
            value_from {
              secret_key_ref {
                name = "dotenv-keys"
                key  = "oauth-service"
              }
            }
          }
          volume_mount {
            name       = "data"
            mount_path = "/app/data"
          }
        }

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = module.storage.default_volume_pvc_name
          }
        }
      }
    }
  }
}
