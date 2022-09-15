### Exercise 6: Installing Argo Rollouts

This exercise involves installing Argo Rollouts in order to begin configuring blue-green and canary deployments.

#### Install Argo Rollouts

```sh
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
```

You can now view and sync the application at [https://localhost:8080/applications/argo-rollouts](https://localhost:8080/applications/argo-rollouts).
