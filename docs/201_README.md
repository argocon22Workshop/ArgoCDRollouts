## Prerequisites Setup

#### Complete Steps from 101 session
You can find the directions at [docs/101_README.md](../docs/101_README.md).

#### Install Istio
```
brew install istioctl
istioctl install --set profile=demo -y --set values.global.hub=gcr.io/istio-testing --set values.global.tag=1.16-alpha.8a03fdd12a21ce72ec0ecbee21fe0aa07ad835f4
kubectl create namespace argo-rollouts-istio
kubectl label namespace argo-rollouts-istio istio-injection=enabled
```

#### Install kube-prometheus
```
kubectl apply --server-side -f manifests/prometheus/upstream/setup
kubectl label namespace monitoring istio-injection=enabled
kubectl apply -k manifests/prometheus/
```

#### Install Demo App
```
kustomize build manifests/ArgoCD201-RolloutsDemoIstio/ | kubectl apply -f -
```
