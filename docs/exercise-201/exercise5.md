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


#### 3. Apply a new image to the rollout
Start by viewing the logs of all the pods within the deployment.
```
kubectl logs -n argo-rollouts-istio -l app=istio-host-split -f --max-log-requests=10
```

You should see the following noting that there is only one color being shown:
```
2022/09/07 16:24:18 200 - green
2022/09/07 16:24:22 200 - green
2022/09/07 16:24:30 200 - green
```

Now update the image to trigger a rollout using the following command:
```
kubectl -n argo-rollouts-istio patch rollout istio-host-split --type json --patch '[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "ghcr.io/argocon22workshop/rollouts-demo:blue" }]'
```

View the logs again using this command:
```
kubectl logs -n argo-rollouts-istio -l app=istio-host-split -f --max-log-requests=10
```
Notice that now you will see multiple colors:
```
2022/09/07 16:29:47 200 - green
2022/09/07 16:29:49 200 - green
2022/09/07 16:29:49 200 - blue
2022/09/07 16:29:49 200 - blue
```

Now lets look at the demo app web UI found at http://localhost we can see that we only see green pixels because with mirroring
we do not send the response back to the end users. This allows us to fully test the canary with read only traffic looking for an
increase in error rates without the end user ever noticing anything.

#### 5. Bonus - Modify rollout to add background analysis to abort when mirrored traffic has high error rate

Use the following image during the rollout to simulate bad requests
```
kubectl -n argo-rollouts-istio patch rollout istio-host-split --type json --patch '[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "ghcr.io/argocon22workshop/rollouts-demo:bad-red" }]'
```

<details>
<summary>Click to view solution</summary>
    1. Modify the rollout to use the background analysis from task 2. 

    # Background analysis snippet from task 2:
    ...
      analysis:
        templates:
          - templateName: success-rate
        startingStep: 1
        args:
          - name: service-name
            value: istio-host-split-canary
    ...
</details>