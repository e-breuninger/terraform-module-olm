terraform {
  required_version = "~>1.2"
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

variable "olm_version" {
  type        = string
  description = "Version of the operator lifecycle manager."
  default     = "v0.18.3"
}

locals {
  olm_base_url = format(
    "https://github.com/operator-framework/operator-lifecycle-manager/releases/download/%s",
    var.olm_version
  )
  # Make sure dependencies are resolved correctly, this is important in context of terraform destroy to make sure the
  # controller is not being deleted before the apiservice resource, otherwise some finalizers will never finalize.
  olm_deployment_manifests = toset([
    "/api/v1/namespaces/olm",
    "/api/v1/namespaces/operators",
    "/api/v1/namespaces/olm/serviceaccounts/olm-operator-serviceaccount",
    "/apis/rbac.authorization.k8s.io/v1/clusterrolebindings/olm-operator-binding-olm",
    "/apis/rbac.authorization.k8s.io/v1/clusterroles/system:controller:operator-lifecycle-manager",
    "/apis/apps/v1/namespaces/olm/deployments/olm-operator"
  ])
  olm_manifests = setsubtract(keys(data.kubectl_file_documents.olm.manifests), local.olm_deployment_manifests)
}

data "http" "olm_crds" {
  url = format("%s/crds.yaml", local.olm_base_url)
}

data "http" "olm" {
  url = format("%s/olm.yaml", local.olm_base_url)
}

data "kubectl_file_documents" "olm_crds" {
  content = data.http.olm_crds.response_body
}

data "kubectl_file_documents" "olm" {
  content = data.http.olm.response_body
}

resource "kubectl_manifest" "olm_crds" {
  for_each  = data.kubectl_file_documents.olm_crds.manifests
  yaml_body = each.value
  wait      = true
}

resource "kubectl_manifest" "olm_deployment" {
  for_each  = local.olm_deployment_manifests
  yaml_body = data.kubectl_file_documents.olm.manifests[each.value]
  depends_on = [
    kubectl_manifest.olm_crds
  ]
  wait = true
}

resource "kubectl_manifest" "olm" {
  for_each  = local.olm_manifests
  yaml_body = data.kubectl_file_documents.olm.manifests[each.value]
  depends_on = [
    kubectl_manifest.olm_deployment
  ]
  wait = true
}
