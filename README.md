# Terraform Module OLM

Installs [Operator Lifecycle Manager](https://github.com/operator-framework/operator-lifecycle-manager/)
into a Kubernetes cluster.

## Example

```terraform
module "olm" {
  source  = "e-breuninger/olm/module"
  version = "v2.1.0"
  # renovate: datasource=github-releases depName=operator-framework/operator-lifecycle-manager
  olm_version = "v0.26.0"
}

resource "some_resource" "operator_subscription" {
  depends_on = [
    module.olm.subscription_resource
  ]
}
```

<!-- BEGIN_TF_DOCS -->


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_olm_version"></a> [olm\_version](#input\_olm\_version) | Version of the operator lifecycle manager. | `string` | `"v0.26.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subscription_resource"></a> [subscription\_resource](#output\_subscription\_resource) | The crd for catalog subscriptions. Use this output to depend on the crd for subscriptions to be applied. |
<!-- END_TF_DOCS -->

## Upgrade to v2.0.0

Remove olm resources from state

```bash
terraform state rm 'module.olm.kubectl_manifest.olm["/apis/apps/v1/namespaces/olm/deployments/catalog-operator"]'
terraform state rm 'module.olm.kubectl_manifest.olm["/apis/operators.coreos.com/v1/namespaces/olm/operatorgroups/olm-operators"]'
terraform state rm 'module.olm.kubectl_manifest.olm["/apis/operators.coreos.com/v1/namespaces/operators/operatorgroups/global-operators"]'
terraform state rm 'module.olm.kubectl_manifest.olm["/apis/operators.coreos.com/v1alpha1/namespaces/olm/catalogsources/operatorhubio-catalog"]'
terraform state rm 'module.olm.kubectl_manifest.olm["/apis/operators.coreos.com/v1alpha1/namespaces/olm/clusterserviceversions/packageserver"]'
terraform state rm 'module.olm.kubectl_manifest.olm["/apis/rbac.authorization.k8s.io/v1/clusterroles/aggregate-olm-edit"]'
terraform state rm 'module.olm.kubectl_manifest.olm["/apis/rbac.authorization.k8s.io/v1/clusterroles/aggregate-olm-view"]'
terraform state rm 'module.olm.kubectl_manifest.olm_crds["/apis/apiextensions.k8s.io/v1/customresourcedefinitions/catalogsources.operators.coreos.com"]'
terraform state rm 'module.olm.kubectl_manifest.olm_crds["/apis/apiextensions.k8s.io/v1/customresourcedefinitions/clusterserviceversions.operators.coreos.com"]'
terraform state rm 'module.olm.kubectl_manifest.olm_crds["/apis/apiextensions.k8s.io/v1/customresourcedefinitions/installplans.operators.coreos.com"]'
terraform state rm 'module.olm.kubectl_manifest.olm_crds["/apis/apiextensions.k8s.io/v1/customresourcedefinitions/operatorconditions.operators.coreos.com"]'
terraform state rm 'module.olm.kubectl_manifest.olm_crds["/apis/apiextensions.k8s.io/v1/customresourcedefinitions/operatorgroups.operators.coreos.com"]'
terraform state rm 'module.olm.kubectl_manifest.olm_crds["/apis/apiextensions.k8s.io/v1/customresourcedefinitions/operators.operators.coreos.com"]'
terraform state rm 'module.olm.kubectl_manifest.olm_crds["/apis/apiextensions.k8s.io/v1/customresourcedefinitions/subscriptions.operators.coreos.com"]'
terraform state rm 'module.olm.kubectl_manifest.olm_deployment["/api/v1/namespaces/olm"]'
terraform state rm 'module.olm.kubectl_manifest.olm_deployment["/api/v1/namespaces/olm/serviceaccounts/olm-operator-serviceaccount"]'
terraform state rm 'module.olm.kubectl_manifest.olm_deployment["/api/v1/namespaces/operators"]'
terraform state rm 'module.olm.kubectl_manifest.olm_deployment["/apis/apps/v1/namespaces/olm/deployments/olm-operator"]'
terraform state rm 'module.olm.kubectl_manifest.olm_deployment["/apis/rbac.authorization.k8s.io/v1/clusterrolebindings/olm-operator-binding-olm"]'
terraform state rm 'module.olm.kubectl_manifest.olm_deployment["/apis/rbac.authorization.k8s.io/v1/clusterroles/system:controller:operator-lifecycle-manager"]'
```

Import to new olm module kustomization resources. Replace `module.olm` with `module.MODULE_NAME`.

```terraform
import {
  to = module.olm.module.kustomization.kustomization_resource.p0["_/Namespace/_/olm"]
  id = "_/Namespace/_/olm"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p0["_/Namespace/_/operators"]
  id = "_/Namespace/_/operators"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p0["apiextensions.k8s.io/CustomResourceDefinition/_/catalogsources.operators.coreos.com"]
  id = "apiextensions.k8s.io/CustomResourceDefinition/_/catalogsources.operators.coreos.com"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p0["apiextensions.k8s.io/CustomResourceDefinition/_/clusterserviceversions.operators.coreos.com"]
  id = "apiextensions.k8s.io/CustomResourceDefinition/_/clusterserviceversions.operators.coreos.com"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p0["apiextensions.k8s.io/CustomResourceDefinition/_/installplans.operators.coreos.com"]
  id = "apiextensions.k8s.io/CustomResourceDefinition/_/installplans.operators.coreos.com"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p0["apiextensions.k8s.io/CustomResourceDefinition/_/operatorconditions.operators.coreos.com"]
  id = "apiextensions.k8s.io/CustomResourceDefinition/_/operatorconditions.operators.coreos.com"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p0["apiextensions.k8s.io/CustomResourceDefinition/_/operatorgroups.operators.coreos.com"]
  id = "apiextensions.k8s.io/CustomResourceDefinition/_/operatorgroups.operators.coreos.com"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p0["apiextensions.k8s.io/CustomResourceDefinition/_/operators.operators.coreos.com"]
  id = "apiextensions.k8s.io/CustomResourceDefinition/_/operators.operators.coreos.com"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p0["apiextensions.k8s.io/CustomResourceDefinition/_/subscriptions.operators.coreos.com"]
  id = "apiextensions.k8s.io/CustomResourceDefinition/_/subscriptions.operators.coreos.com"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p1["_/ServiceAccount/olm/olm-operator-serviceaccount"]
  id = "_/ServiceAccount/olm/olm-operator-serviceaccount"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p1["apps/Deployment/olm/catalog-operator"]
  id = "apps/Deployment/olm/catalog-operator"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p1["apps/Deployment/olm/olm-operator"]
  id = "apps/Deployment/olm/olm-operator"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p1["operators.coreos.com/CatalogSource/olm/operatorhubio-catalog"]
  id = "operators.coreos.com/CatalogSource/olm/operatorhubio-catalog"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p1["operators.coreos.com/ClusterServiceVersion/olm/packageserver"]
  id = "operators.coreos.com/ClusterServiceVersion/olm/packageserver"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p1["operators.coreos.com/OperatorGroup/olm/olm-operators"]
  id = "operators.coreos.com/OperatorGroup/olm/olm-operators"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p1["operators.coreos.com/OperatorGroup/operators/global-operators"]
  id = "operators.coreos.com/OperatorGroup/operators/global-operators"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p1["rbac.authorization.k8s.io/ClusterRole/_/aggregate-olm-edit"]
  id = "rbac.authorization.k8s.io/ClusterRole/_/aggregate-olm-edit"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p1["rbac.authorization.k8s.io/ClusterRole/_/aggregate-olm-view"]
  id = "rbac.authorization.k8s.io/ClusterRole/_/aggregate-olm-view"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p1["rbac.authorization.k8s.io/ClusterRole/_/system:controller:operator-lifecycle-manager"]
  id = "rbac.authorization.k8s.io/ClusterRole/_/system:controller:operator-lifecycle-manager"
}
import {
  to = module.olm.module.kustomization.kustomization_resource.p1["rbac.authorization.k8s.io/ClusterRoleBinding/_/olm-operator-binding-olm"]
  id = "rbac.authorization.k8s.io/ClusterRoleBinding/_/olm-operator-binding-olm"
}
```
