# Argo CD / Rollouts Workshop 201

## Install prerequisites

### Requirements from [101 session](101_README.md) (if you did not attend)

Fork this repo then run the command below changing `<username>` to your GitHub username.

```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Gets the generated argocd password, might take a little bit to allow argocd to fully start
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Username: admin password: from output of command above
USERNAME="<username>"
argocd --port-forward --port-forward-namespace argocd login
argocd --port-forward --port-forward-namespace argocd repo add "https://github.com/$USERNAME/ArgoCDRollouts"
argocd --port-forward --port-forward-namespace argocd app create argo-rollouts --repo "https://github.com/$USERNAME/ArgoCDRollouts" --path manifests/ArgoCD101-RolloutsController --dest-namespace argo-rollouts --dest-server https://kubernetes.default.svc
argocd --port-forward --port-forward-namespace argocd app sync argo-rollouts
```

### Install Istio

```sh
brew install istioctl
istioctl install --set profile=demo -y --set values.global.hub=gcr.io/istio-testing --set values.global.tag=1.16-alpha.8a03fdd12a21ce72ec0ecbee21fe0aa07ad835f4
kubectl create namespace argo-rollouts-istio
kubectl label namespace argo-rollouts-istio istio-injection=enabled
```

### Install kube-prometheus
```sh
kubectl apply --server-side -f manifests/prometheus/upstream/setup
kubectl apply -k manifests/prometheus/
```

### Install Demo App

```sh
kustomize build manifests/ArgoCD201-RolloutsDemoCanaryIstio/ | kubectl apply -f -
```

Run `kubectl get services -n istio-system | grep istio-ingressgateway` and wait for `<pending>` to switch to localhost
if it does not try quiting and restarting docker for desktop. You can also try resetting docker for desktops kubernetes cluster.

Now visit http://localhost to view the demo app and run `kubectl argo rollouts dashboard` cmd then visit http://localhost:3100 to view rollouts
dashboard.

## Try some Argo Rollouts exercises

[Task 1](Tasks-201-Rollouts/task1.md) - Perform a canary rollout with Istio

[Task 2](Tasks-201-Rollouts/task2.md) - Perform a canary rollout with AnalysisRun and auto rollback

[Task 3](Tasks-201-Rollouts/task3.md) - Create a canary rollout with a traffic mirroring step
