### 1. Install and review the Rollout manifest with mirror step.

Explore the Rollout manifest with analysis run found [here](../../manifests/ArgoCD201-RolloutsDemoMirrorIstio).

Install via this command which will replace Task 2's deployed rollout:
```
kustomize build manifests/ArgoCD201-RolloutsDemoMirrorIstio/ | kubectl apply -f -

# We will promote full to make sure we are fully deployed
kubectl argo rollouts promote --full istio-host-split -n argo-rollouts-istio
```

### 2. Looking at the manifest we see the mirror step defined as:
```
steps:
  - setCanaryScale: # We scale just the pod counts to 50% of the stable
      weight: 50
  - setMirrorRoute:
      name: mirror-route
      percentage: 50
      match:
      - method:
          exact: POST
        path:
          prefix: /color
  - pause: {}
```

Notice how we are able to control the percentage that we mirror as well as the specific http path and method.
Rollout supports a full array of filters you can use to control what http routes get mirrored. You can read more
about that [here](https://argoproj.github.io/argo-rollouts/features/traffic-management/#traffic-routing-mirroring-traffic-to-canary)

