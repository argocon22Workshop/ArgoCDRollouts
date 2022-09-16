### Exercise 6: Performing a canary rollout with a traffic header step

#### 6.1. Install and review the Rollout manifest with header step.

Explore the Rollout manifest with analysis run found [here](../../manifests/ArgoCD201-RolloutsDemoHeaderIstio).

Install via this command, which will replace any previously deployed rollout:
```sh
kustomize build manifests/ArgoCD201-RolloutsDemoHeaderIstio/ | kubectl apply -f -

# We will promote full to make sure we are fully deployed
kubectl argo rollouts promote --full istio-host-split -n argo-rollouts-istio
```

#### 6.2. Looking at the manifest we see the mirror step defined as:
```yaml
steps:
  - setCanaryScale:
      weight: 50
  - setHeaderRoute:
      name: canary-header
      match:
        - headerName: Canary-Users
          headerValue:
            exact: "true"
  - pause: {}
```

This will send 100% of the traffic to the canary if the header Canary-Users is set to true.
This is a great way to test out a new version of your application without having to change any code. You can read more about this feature [here](https://argoproj.github.io/argo-rollouts/features/traffic-management/#traffic-routing-based-on-a-header-values-for-canary)

#### 6.3. Apply a new image to the rollout
Now update the image to trigger a rollout using the following command:
```sh
kubectl -n argo-rollouts-istio patch rollout istio-host-split --type json --patch '[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "ghcr.io/argocon22workshop/rollouts-demo:yellow" }]'
```

Now let's test out the new version of the application. We will use curl to send a request with the Canary-Users header set to true.
```sh
curl -X POST -H "Canary-Users: true" http://localhost/color
```

You should see the following response:
```
"yellow"
```

Now let's send a request without the Canary-Users header set to true.
```sh
curl -X POST http://localhost/color
```

The response should be:
```
"green"
```

You can look at the Demo App UI to see that we are not sending any UI traffic to the canary.
