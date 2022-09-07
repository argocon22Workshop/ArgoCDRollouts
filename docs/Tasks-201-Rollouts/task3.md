### 1. Install and review the Rollout manifest with mirror step.

Explore the Rollout manifest with analysis run found [here](../../manifests/ArgoCD201-RolloutsDemoMirrorIstio).

Install via this command which will replace Task 2's deployed rollout:
```
kustomize build manifests/ArgoCD201-RolloutsDemoMirrorIstio/ | kubectl apply -f -

# We will promote full to make sure we are fully deployed
kubectl argo rollouts promote --full istio-host-split -n argo-rollouts-istio
```