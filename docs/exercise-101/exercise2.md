### Using with Argo CD CLI

In this exercise we will deploy our first application using Argo CD CLI.

#### Set up a simple test application

Replace `<username>` with your GitHub username in the first command below.

```sh
WORKSHOP_USER="<username>"
argocd --port-forward --port-forward-namespace argocd login
argocd --port-forward-namespace argocd repo add "https://github.com/$WORKSHOP_USER/ArgoCDRollouts"
argocd --port-forward-namespace argocd app create guestbook --repo "https://github.com/$WORKSHOP_USER/ArgoCDRollouts" --path manifests/ArgoCD101-GuestbookManifests --dest-namespace default --dest-server https://kubernetes.default.svc
argocd --port-forward-namespace argocd app sync guestbook
```
