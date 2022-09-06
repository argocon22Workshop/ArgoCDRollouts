#### 1. Start the Rollout process by editing the image
```
kubectl -n argo-rollouts-istio patch rollout istio-host-split --type json --patch '[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "ghcr.io/argocon22workshop/rollouts-demo:red" }]'
```

View the demo app at http://localhost and see the new color red at roughly 25% this is because we have this defined in our rollout
[spec](../../manifests/ArgoCD201-RolloutsDemoCanaryIstio/canary.yaml#L71):
```
steps:
  - setWeight: 25
  - pause: {}
  - setWeight: 50
  - pause: {}
  - setWeight: 75
  - pause: {}
```

#### 2. Promote the rollout to the next step
```
kubectl argo rollouts promote istio-host-split -n argo-rollouts-istio
```

Now you should see the new color red at roughly 50% of the traffic.

#### 3. Next we will fully promote the rollout to 100% of the traffic
```
kubectl argo rollouts promote --full istio-host-split -n argo-rollouts-istio
```

#### 4. Bonus - You can now perform these same steps using the Argo Rollouts UI

If you do not have the UI running locally yet run the following command:
```
kubectl argo rollouts dashboard
```

Then visit the UI at: http://localhost:3100

You can then update the rollout image to a new color and promote the rollout to the next steps via the UI.
```
kubectl -n argo-rollouts-istio patch rollout istio-host-split --type json --patch '[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "ghcr.io/argocon22workshop/rollouts-demo:green" }]'
```