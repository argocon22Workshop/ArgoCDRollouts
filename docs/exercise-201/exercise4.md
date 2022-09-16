### Exercise 4: Performing a canary rollout with analysis and auto rollback

#### 4.1. Install and review the Rollout manifest with analysis run.

Explore the Rollout manifest with analysis run found [here](../../manifests/ArgoCD201-RolloutsDemoCanaryAnalysisIstio/).

Install via this command, which will replace any previously deployed rollout:
```sh
kustomize build manifests/ArgoCD201-RolloutsDemoCanaryAnalysisIstio/ | kubectl apply -f -

# We will promote full to make sure we are fully deployed
kubectl argo rollouts promote --full istio-host-split -n argo-rollouts-istio
```

#### 4.2. Looking at the manifest there are a few main things to note:

1. The [Analysis query](../../manifests/ArgoCD201-RolloutsDemoCanaryAnalysisIstio/analysis_template.yaml#19) is defined below which would give us the 5xx error rate as a percentage:
```
sum(irate(istio_requests_total{destination_service_name=~"{{args.service-name}}",response_code!~"5.*"}[1m]))
/
sum(irate(istio_requests_total{destination_service_name=~"{{args.service-name}}"}[1m]))
```
2. The Analysis defined in the rollout is a background analysis. This means that the rollout will not wait for the analysis to complete
before progressing. This is useful for cases where you want to run an analysis in the background to gather metrics, but you don't
want to block the rollout from progressing. We will start this background analysis on step 2 of the rollout and pass an
argument to the analysis run of the canary service name to be used in the query.
```yaml
  analysis:
    templates:
      - templateName: success-rate
    startingStep: 3 # delay starting analysis run until setWeight: 35%
    args:
      - name: service-name
        value: istio-host-split-canary
```
3. The steps in the Rollout are defined as:
```yaml
steps:
  - setWeight: 25
  - pause: {}
  - setWeight: 35
  - pause: # Analysis will start here
      duration: 10s
  - setWeight: 50
  - pause:
      duration: 10s
  - setWeight: 75
  - pause:
      duration: 2m
```

#### 4.3. Start the Rollout process by editing the image

```sh
kubectl -n argo-rollouts-istio patch rollout istio-host-split --type json --patch '[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "ghcr.io/argocon22workshop/rollouts-demo:yellow" }]'
```

This will start the rollout and pause at 25% of the traffic being routed to the canary. You can view the rollout status via the UI.

1. Open the demo app [UI](http://localhost) adjust the error rate to 60%.
1. Now promote the rollout which will start the analysis run. We will do this by promoting the rollout to the next step via CLI `kubectl argo rollouts promote istio-host-split -n argo-rollouts-istio`
or via the UI promote button.
1. Now switch back and forth between the rollouts UI and the demo app UI and watch as the analysis run fails and the
rollout automatically rolls back to stable replicaset.

#### 4.4. Retry the rollout without the error rate
Set the demo app error rate back to 0% and retry the rollout. You might need to refresh page.

You can retry the rollout via CLI `kubectl argo rollouts retry rollout istio-host-split -n argo-rollouts-istio` or via the UI retry button.

#### Remember to promote past the first pause.
