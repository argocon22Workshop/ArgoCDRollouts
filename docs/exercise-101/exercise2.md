### Deploy an Application with Gitops

In this exercise we will deploy our first application in ArgoCD using gitops.

#### Set up a simple test application

Fork this repo first then replace `<username>` with your GitHub username in the first command below.

```sh
USERNAME="<username>"
argocd --port-forward --port-forward-namespace argocd login
argocd --port-forward --port-forward-namespace argocd repo add "https://github.com/$USERNAME/ArgoCDRollouts"
argocd --port-forward --port-forward-namespace argocd app create guestbook --repo "https://github.com/$USERNAME/ArgoCDRollouts" --path manifests/ArgoCD101-GuestbookApplicationManifests --dest-namespace default --dest-server https://kubernetes.default.svc
argocd --port-forward --port-forward-namespace argocd app sync guestbook
```
