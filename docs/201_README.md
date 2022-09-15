# Argo CD / Rollouts Workshop 201

### 1. Install prerequisites

Only run through step 1.1 if you did not attend the 101 workshop.

#### 1.1. Prerequisites (if you did not attend)

Make sure you have the Workshop prerequisites from [101 session](101_README.md) installed section 1.

Run the command below changing `<username>` to your GitHub username.

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

#### 1.2. Install Istio

```sh
brew install istioctl
istioctl install --set profile=demo -y --set values.global.tag=1.15.0
kubectl create namespace argo-rollouts-istio
kubectl label namespace argo-rollouts-istio istio-injection=enabled
```

#### 1.3. Install kube-prometheus
```sh
kubectl apply --server-side -f manifests/prometheus/upstream/setup
kubectl apply -k manifests/prometheus/
```

### 2. Advanced Argo CD exercises

- [Exercise 1](exercise-201/exercise1.md) - Configure Users permissions for Argo CD
- [Exercise 2](exercise-201/exercise2.md) - Create dynamic applications with ApplicationSets

### 3. Advanced Argo Rollouts exercises

- [Exercise 3](exercise-201/exercise3.md) - Performing a canary rollout with Istio
- [Exercise 4](exercise-201/exercise4.md) - Performing a canary rollout with analysis and auto rollback
- [Exercise 5](exercise-201/exercise5.md) - Performing a canary rollout with a traffic mirroring step
- [Exercise 6](exercise-201/exercise6.md) - Performing a canary rollout with a traffic header step
