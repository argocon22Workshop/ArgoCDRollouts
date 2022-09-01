## Prerequisites Setup

#### Requirements from 101 session (if you did not attend)
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Get's the generated argocd password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Username: admin password: from output of command above
argocd --port-forward --port-forward-namespace argocd login
argocd --port-forward --port-forward-namespace argocd repo add https://github.com/argocon22Workshop/argoCDRollouts101
argocd --port-forward --port-forward-namespace argocd app create argo-rollouts --repo https://github.com/argocon22Workshop/argoCDRollouts101 --path manifests/ArgoCD101-RolloutsController --dest-namespace argo-rollouts --dest-server https://kubernetes.default.svc
argocd --port-forward --port-forward-namespace argocd app sync argo-rollouts
```

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
kubectl apply -k manifests/prometheus/
```

#### Install Demo App
```
kustomize build manifests/ArgoCD201-RolloutsDemoCanaryIstio/ | kubectl apply -f -
```
