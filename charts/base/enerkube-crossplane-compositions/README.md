# enerkube-crossplane-compositions

This chart contains the following compositions

## enerkube-namespaces

### Description

Enables users to create enerkube conform namespaces on **non-shared clusters** (shared clusters could later also be enabled by adding a prefix with the "management namespace" to the created namespace, so the different user created namespaces would not interfere). 

## Prerequisites
To use this composition it is currently necessary to enable the kubernetes provider and the appropriate providerconfig in the helm-charts "enerkube-crossplane" and "enerkube-crossplane-providerconfig"

## Examples

```yaml
apiVersion: enerkube.conti.de/v1beta1
kind: EnerkubeNamespace
metadata:
  name: enerkube-example
spec:
  parameters:
    name: enerkube-example
    responsible: foo.bar@enercity.de
    alerting:
      - foo.bar@enercity.de
      - kung.fu@enercity.de
    permissions:
      view:
        - namespace: enerkube-test
          serviceAccount: read-only
      edit:
        - namespace: enerkube-test
          serviceAccount: default-login-serviceaccount
  writeConnectionSecretToRef:
    name: enerkube-example
```
