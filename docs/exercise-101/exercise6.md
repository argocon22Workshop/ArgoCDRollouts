### Exercise 6: Installing Argo Rollouts

This exercise involves installing Argo Rollouts in order to begin configuring blue-green and canary deployments.

#### Install Argo Rollouts

```sh
WORKSHOP_USER="<username>"
argocd --port-forward --port-forward-namespace argocd login
argocd --port-forward-namespace argocd repo add "https://github.com/$WORKSHOP_USER/ArgoCDRollouts"
argocd --port-forward-namespace argocd app create argo-rollouts --repo "https://github.com/$WORKSHOP_USER/ArgoCDRollouts" --path manifests/ArgoCD101-RolloutsController --dest-namespace argo-rollouts --dest-server https://kubernetes.default.svc
argocd --port-forward-namespace argocd app sync argo-rollouts
```

You can now view the application at [https://localhost:8080/applications/argo-rollouts](https://localhost:8080/applications/argo-rollouts).
