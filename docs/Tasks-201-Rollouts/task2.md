#### 1. Install and review the Rollout manifest with analysis run.

Explore the Rollout manifest with analysis run found [here](../../manifests/ArgoCD201-RolloutsDemoCanaryAnalysisIstio/).

Install via this command which will replace Task 1's deployed rollout:
```
kustomize build manifests/ArgoCD201-RolloutsDemoCanaryAnalysisIstio/ | kubectl apply -f -
```

Looking at the manifest there are a few main things to note:

1. The Analysis query is defined below which would give us the 5xx error rate as a percentage:
```
sum(irate(istio_requests_total{destination_service_name=~"{{args.service-name}}",response_code!~"5.*"}[1m])) 
/
sum(irate(istio_requests_total{destination_service_name=~"{{args.service-name}}"}[1m]))
```
2. The Analysis defined in the rollout is a background analysis. This means that the rollout will not wait for the analysis to complete 
before progressing. This is useful for cases where you want to run an analysis in the background to gather metrics, but you don't 
want to block the rollout from progressing. We will start this background analysis on step 2 of the rollout:
```
  analysis:
    templates:
      - templateName: success-rate
    startingStep: 2 # delay starting analysis run until setWeight: 40%
    args:
      - name: service-name
        value: istio-host-split-canary
```
3. The steps in the Rollout are defined as:
```
steps:
  - setWeight: 25
  - pause: # The background analysis will start here.
      duration: 10s
  - setWeight: 50
  - pause:
      duration: 10s
  - setWeight: 75
  - pause:
      duration: 2m
```