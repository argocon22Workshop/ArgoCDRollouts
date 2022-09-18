### Exercise 3: Performing a canary rollout with Istio

#### 3.1. Install the Argo Rollouts Demo App

```sh
kustomize build manifests/ArgoCD201-RolloutsDemoCanaryIstio/ | kubectl apply -f -
```

Run `kubectl get services -n istio-system | grep istio-ingressgateway` and wait for `<pending>` to switch to localhost
if it does not try quiting and restarting docker for desktop. You can also try resetting docker for desktops kubernetes cluster.

Now visit http://localhost to view the demo app and run `kubectl argo rollouts dashboard` cmd then visit http://localhost:3100/rollouts to view rollouts
dashboard.

#### 3.1. Start the Rollout process by editing the image
```
kubectl -n argo-rollouts-istio patch rollout istio-host-split --type json --patch '[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "ghcr.io/argocon22workshop/rollouts-demo:red" }]'
```

View the demo app at http://localhost and see the new color red at roughly 25% this is because we have this defined in our rollout
[spec](../../manifests/ArgoCD201-RolloutsDemoCanaryIstio/canary.yaml#L71):
```yaml
steps:
  - setWeight: 25
  - pause: {}
  - setWeight: 50
  - pause: {}
  - setWeight: 75
  - pause: {}
```

#### 3.3. Promote the rollout to the next step
Because we have executed a rollout and are now in the middle of we are currently at the second step. This
is an indefinite pause. We will now move on to the next step by promoting using the CLI command below.
```sh
kubectl argo rollouts promote istio-host-split -n argo-rollouts-istio
```

Now you should see the new color red at roughly 50% of the traffic.

#### 3.4. Next we will fully promote the rollout to 100% of the traffic
We will now use full promote to skip going to the 75% step and go strait to fully deploying the new color.
```sh
kubectl argo rollouts promote --full istio-host-split -n argo-rollouts-istio
```

#### 3.5. Perform these same steps using the Argo Rollouts UI

If you do not have the UI running locally yet run the following command:
```sh
kubectl argo rollouts dashboard
```

Then visit the UI at: http://localhost:3100/rollouts

You can then update the rollout image to a new color and promote the rollout to the next steps via the UI.
```sh
kubectl -n argo-rollouts-istio patch rollout istio-host-split --type json --patch '[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "ghcr.io/argocon22workshop/rollouts-demo:green" }]'
```