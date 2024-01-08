terraform {
  required_version = "~>1.2"
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.2"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "~> 0.9"
    }
  }
}

variable "olm_version" {
  type        = string
  description = "Version of the operator lifecycle manager."
  default     = "v0.26.0"
}

locals {
  olm_base_url = format(
    "https://github.com/operator-framework/operator-lifecycle-manager/releases/download/%s",
    var.olm_version
  )
}

data "kustomization_overlay" "olm" {
  resources = [
    format("%s/crds.yaml", local.olm_base_url),
    format("%s/olm.yaml", local.olm_base_url)
  ]
}

module "kustomization" {
  source                    = "e-breuninger/kustomization/module"
  version                   = "1.0.0"
  kustomization_data_source = data.kustomization_overlay.olm
}
