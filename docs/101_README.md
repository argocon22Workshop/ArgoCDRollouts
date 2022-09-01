## Prerequisites Setup

For the 101 session we will require Docker for Desktop with Kubernetes Enabled, and homebrew installed.

You can install Docker for Desktop by following the instructions on the [Docker for Desktop](https://docs.docker.com/get-started/#download-and-install-docker) page.

You can install homebrew via the following command:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

You can check your setup by running the precheck script found at `scripts/prereq-check.sh` of this repo.

## Setup Argo CLI Tools

### OSX
```bash
brew install argocd
brew install argoproj/tap/kubectl-argo-rollouts
```

## Setup ArgoCD
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Access UI
Run the following command to access the UI in a new terminal window:

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
Visit the UI at `http://localhost:8080`.

#### Username: `admin` Password: `run command below`
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Deploy guestbook application via GitOps
 ###
 1. Fork [ArgoCon22 Repo]( https://github.com/argocon22Workshop/ArgoCDRollouts )
 1. Clone the forked repo `git clone git@github.com:<username>/ArgoCDRollouts.git`
 1. Edit `manifest/ArgoCD101-GuestbookGitOps/guestbook_application.yaml` replace <username> with your Github username that you forked the repo too.
 1. Deploy the app using kustomize. Username: `admin` Password: `from command above`
    ```
    kustomize build manifests/ArgoCD101-GuestbookGitOps/ | kubectl apply -f -
    argocd --port-forward --port-forward-namespace argocd login
    argocd --port-forward --port-forward-namespace argocd app sync guestbook
    ```

## Setup guestbook application via CLI
```
argocd --port-forward --port-forward-namespace argocd login
argocd --port-forward --port-forward-namespace argocd repo add https://github.com/<username>/ArgoCDRollouts
argocd --port-forward --port-forward-namespace argocd app create guestbook --repo https://github.com/<username>/ArgoCDRollouts --path manifests/ArgoCD101-GuestbookApplicationManifests --dest-namespace default --dest-server https://kubernetes.default.svc
argocd --port-forward --port-forward-namespace argocd app sync guestbook
```



## Setup Argo Rollouts Controller via CLI
```
argocd --port-forward --port-forward-namespace argocd login
argocd --port-forward --port-forward-namespace argocd repo add https://github.com/<username>/ArgoCDRollouts
argocd --port-forward --port-forward-namespace argocd app create argo-rollouts --repo https://github.com/<username>/ArgoCDRollouts --path manifests/ArgoCD101-RolloutsController --dest-namespace argo-rollouts --dest-server https://kubernetes.default.svc
argocd --port-forward --port-forward-namespace argocd app sync argo-rollouts
```

You can now view and sync the application at: https://localhost:8080/applications/argo-rollouts

## Setup Argo Rollouts Demo App via UI
<img src="../assets/mainscreen.jpg"  width="1024" height="512">
<img src="../assets/createapp-1.jpg"  width="1024" height="512">
<img src="../assets/createapp-2.jpg"  width="1024" height="512">
