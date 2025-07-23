# enerkube-namespace

## Create kubeconfig files

Kubeconfig files are by default created in the users namespace. This behavior can be changed with Helm Values. 

To get the kubeconfig files for the customer you can simply use this command:

```bash
# Change <namespace-name> to your namespace
NAMESPACE=<namespace-name>; for kubeconfig in $(kubectl get secret -n $NAMESPACE -o custom-columns=NAME:.metadata.name --no-headers | grep kubeconfig); do kubectl get secret -n $NAMESPACE $kubeconfig -o jsonpath='{.data.kubeconfig}' | base64 -d > $kubeconfig; done
```

The two files will be saved to your current directory