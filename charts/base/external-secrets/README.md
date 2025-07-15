# external-secrets-chart

## Migration

## IMPORTANT: Do not deploy the GitOps chart until the resources have been migrated from Terraform, or the CRD's will be lost due to configuration issues while trying to deploy the chart.

### Remove old resource without removing of the CRDs

#### Change Ownership of CRDs

```sh
kubectl annotate --overwrite crd -l external-secrets.io/component=controller meta.helm.sh/release-namespace=enerkube-system meta.helm.sh/release-name=external-secret-operator

kubectl get crd -l external-secrets.io/component=controller -o name | xargs -I {} kubectl patch {} --type='json' -p='[{"op": "replace", "path": "/spec/conversion/webhook/clientConfig/service/namespace", "value": "enerkube-system"}]'
```

### Remove remaining helmrelease resources (except CRDs) and terraform module

```sh
terraform init
terraform state rm module.external-secrets-operator.helm_release.external_secrets_operator
terraform destroy -target=module.external-secrets-operator -auto-approve
kubectl delete all,sa,role,rolebinding,clusterrolebinding,clusterrole,secret,validatingwebhookconfiguration -l app.kubernetes.io/instance=external-secrets-operator -n kube-system
kubectl delete secret -n kube-system sh.helm.release.v1.external-secrets-operator.v1
kubectl delete ss,css -A --all
```

### Remove the external-secrets-operator.tf and commit it.

```sh
git rm external-secrets-operator.tf
git commit -m "Migrate external-secrets-operator to gitops" external-secrets-operator.tf
git push
```

## Rollout new enerkube-lb-controller via GitOps
## Now is the step where you can safely deploy the Helm Chart to the enerkube-gitops repo


### Optional, manually trigger a sync of the latest revision, so it applies the helm releases in case it isn't showing up yet
```sh
flux reconcile source git flux2-sync
flux reconcile kustomization system
```