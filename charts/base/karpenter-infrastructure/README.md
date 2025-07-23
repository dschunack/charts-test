# karpenter-crossplane-chart

## Migration

### Remove old resource without removing of the CRDs

#### Change Ownership of CRDs

```sh
for crd in ec2nodeclasses.karpenter.k8s.aws nodeclaims.karpenter.sh nodepools.karpenter.sh
do
    kubectl patch crd $crd -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "karpenter", "meta.helm.sh/release-namespace": "enerkube-system", "helm.sh/resource-policy": "keep"}}}'
    kubectl patch crd $crd -p '{"metadata": {"labels": {"helm.toolkit.fluxcd.io/name": "karpente-stack", "helm.toolkit.fluxcd.io/namespace": "enerkube-system"}}}'
done

for pool in $(kubectl get nodepools.karpenter.sh --no-headers --server-print=false |awk '{print $1}')
do
  echo $pool
  kubectl patch nodepools.karpenter.sh $pool --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "karpenter", "meta.helm.sh/release-namespace": "enerkube-system", "helm.sh/resource-policy": "keep"}}}'
  kubectl patch nodepools.karpenter.sh $pool --type=merge -p '{"metadata": {"labels": {"helm.toolkit.fluxcd.io/name": "karpenter-stack", "helm.toolkit.fluxcd.io/namespace": "enerkube-system"}}}'
done

for class in $(kubectl get ec2nodeclasses.karpenter.k8s.aws  --no-headers --server-print=false |awk '{print $1}')
do
  echo $class
  kubectl patch ec2nodeclasses.karpenter.k8s.aws $class --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "karpenter", "meta.helm.sh/release-namespace": "enerkube-system", "helm.sh/resource-policy": "keep"}}}'
  kubectl patch ec2nodeclasses.karpenter.k8s.aws $class --type=merge -p '{"metadata": {"labels": {"helm.toolkit.fluxcd.io/name": "karpenter-stack", "helm.toolkit.fluxcd.io/namespace": "enerkube-system"}}}'
done

kubectl -n kube-system delete secrets -l name=karpenter-crd
kubectl -n kube-system delete secrets -l name=karpenter-nodepool 
```

### Remove terraform module

```sh
terraform init
terraform destroy -target=module.karpenter
```

Remove the karpente.tf and commit it.

```sh
git rm karpenter.tf
git commit -m"Migrate karpenter to gitops" karpenter.tf
git push
```

## Rollout new enerkube-karpenter via GitOps

** Make sure that config_map_worker_role_arn and config_map_vpc_id are set in flux.tf!**

```sh
flux reconcile source git flux2-sync
flux reconcile kustomization system
```

Restart helm deployment if something goes wrong

```sh
flux reconcile -n enerkube-system helmrelease karpenter-stack
```
