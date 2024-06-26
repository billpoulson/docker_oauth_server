# module "simple_oauth_service" {
#   source         = "../../modules/services"
#   env            = var.env
#   namespace      = var.namespace
#   name           = module.simple_oauth_deployment.name
#   container_port = 8000
#   expose_port    = 80
# }
module "simple_oauth_service" {
  source         = "../../modules/services"
  env            = var.env
  namespace      = var.namespace
  name           = kubernetes_deployment_v1.oauth_manager.metadata[0].name
  container_port = 8000
  expose_port    = 80
}

module "maint_site_service" {
  source         = "../../modules/services"
  env            = var.env
  namespace      = var.namespace
  name           = kubernetes_deployment_v1.maint-site.metadata[0].name
  container_port = 80
  expose_port    = 80
}
