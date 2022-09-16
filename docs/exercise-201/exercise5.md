### Exercise 5: Performing a canary rollout with a traffic mirroring step

#### 5.1. Install and review the Rollout manifest with mirror step.

Explore the Rollout manifest with analysis run found [here](../../manifests/ArgoCD201-RolloutsDemoMirrorIstio).

Install via this command, which will replace any previously deployed rollout:
```sh
kustomize build manifests/ArgoCD201-RolloutsDemoMirrorIstio/ | kubectl apply -f -

# We will promote full to make sure we are fully deployed
kubectl argo rollouts promote --full istio-host-split -n argo-rollouts-istio
```

#### 5.2. Looking at the manifest we see the mirror step defined as:
```yaml
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

We need to be able to control the paths that get mirrored because we do not want to mirror paths that modify data because
it could cause undesired modifications to the state of the app such as creating duplicate entries.


##### 5.3. Apply a new image to the rollout
Start by viewing the logs of all the pods within the deployment.
```sh
kubectl logs -n argo-rollouts-istio -l app=istio-host-split -f --max-log-requests=10
```

You should see the following noting that there is only one color being shown:
```
2022/09/07 16:24:18 200 - green
2022/09/07 16:24:22 200 - green
2022/09/07 16:24:30 200 - green
```

Now update the image to trigger a rollout using the following command:
```sh
kubectl -n argo-rollouts-istio patch rollout istio-host-split --type json --patch '[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "ghcr.io/argocon22workshop/rollouts-demo:blue" }]'
```

View the logs again using this command:
```sh
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

##### 5.4. Modify rollout to add background analysis

Now let's modify the rollout to add background analysis. The analysis will watch the mirrored traffic going to the canary for high error rates and
abort if they cross the configured threshold. The end user of the demo app as we have seen will not notice any issues because the errors will
only be happening in the mirrored traffic.

<details>
  <summary>
    Click to view solution
  </summary>

Modify the rollout to use the background analysis from exercise 4.

Background analysis snippet from exercise 4  with a change to the starting step so it works with the mirrored rollout configuration:
  ```yaml
  ...
    analysis:
      templates:
        - templateName: success-rate
      startingStep: 1
      args:
        - name: service-name
          value: istio-host-split-canary
  ...
  ```
You can use kubectl edit to modify the rollout and add the above snippet the same location found [here](../../manifests/ArgoCD201-RolloutsDemoCanaryAnalysisIstio/canary.yaml#L61-L67):

</details>

After making the changes to the rollout object you can use this cmd to trigger a rollout with a bad image:
```sh
kubectl -n argo-rollouts-istio patch rollout istio-host-split --type json --patch '[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "ghcr.io/argocon22workshop/rollouts-demo:bad-red" }]'
```
