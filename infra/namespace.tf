
resource "kubernetes_namespace_v1" "sample_app" {
  metadata {
    name = "sample-app"
  }
}
