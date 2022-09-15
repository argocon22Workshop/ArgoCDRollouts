## 1. Workshop 201 Prerequisites

Only run through step 1.1 if you did not attend the 101 workshop.

### 1.1. Initial Setup

**This is only required if you did not attend the workshop 101**

If you attented the workshop 101 please skip to the step 1.2 below.

Make sure you have executed the prerequisites from the [101 session](101_prereqs.md).

Run the commands below changing `<username>` to your GitHub username.

```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Gets the generated argocd password, might take a little bit to allow argocd to fully start
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Username: admin password: from output of command above
WORKSHOP_USER="<username>"
argocd --port-forward --port-forward-namespace argocd login
argocd --port-forward-namespace argocd repo add "https://github.com/$WORKSHOP_USER/ArgoCDRollouts"
argocd --port-forward-namespace argocd app create argo-rollouts --repo "https://github.com/$WORKSHOP_USER/ArgoCDRollouts" --path manifests/ArgoCD101-RolloutsController --dest-namespace argo-rollouts --dest-server https://kubernetes.default.svc
argocd --port-forward-namespace argocd app sync argo-rollouts
```

### 1.2. Install Kustomize

```sh
brew install kustomize
```

### 1.3. Install Istio

```sh
brew install istioctl
istioctl install --set profile=demo -y --set values.global.tag=1.15.0
kubectl create namespace argo-rollouts-istio
kubectl label namespace argo-rollouts-istio istio-injection=enabled
```

### 1.4. Install kube-prometheus
```sh
kubectl apply --server-side -f manifests/prometheus/upstream/setup
kubectl apply -k manifests/prometheus/
```
