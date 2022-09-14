### Deploy an Application with Gitops

#### Overview

Argo CD applications, projects and settings can be defined declaratively using Kubernetes manifests. Argo CD comes with its own crd that can be stored in github repo, and applied in a target cluster using kubectl or  using Argo CD.
To setup declarative, you need to define the Application manifest, which uses your source repo.

#### Exercises

1. Delete any app with the name guestbook. The app will be recreated using the Application manifest file.
```
argocd --port-forward-namespace argocd app delete guestbook --cascade
```
1. Edit the file in `manifests/ArgoCD101-GuestbookGitOps/guestbook_application.yaml` and replace the `<username>` with your Github username that you used to fork the repo.
1. Commit the changes and push to the main branch of your forked repo.
1. Deploy the app using Application manifest using the user id `admin` and `password`.

```
argocd --port-forward --port-forward-namespace argocd login
argocd --port-forward-namespace argocd app create guestbook-gitops --repo "https://github.com/$WORKSHOP_USER/ArgoCDRollouts" --path manifests/ArgoCD101-GuestbookGitOps --dest-namespace default --dest-server https://kubernetes.default.svc
```

1. Sync the application
```
argocd --port-forward-namespace argocd app sync guestbook-gitops
```

#### Optional Exercise

Modify the `manifests/ArgoCD101-GuestbookGitOps/guestbook_application.yaml` file configuring sync policies to get the following outcome:
- Changes in the manifests are applied automatically
- Removed manifests are excluded from the cluster
- Application will try to self heal if state in cluster changes


<details>
<summary>Click to view solution</summary>
<ol>
<li>Edit the  manifests/ArgoCD101-GuestbookGitOps/guestbook_application.yaml and add the following code in the manifest path spec.syncPolicy.

```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```
</li>
<li>Commit the changes and push to the main branch of your forked repo.</li>
<li>Apply the new manifest to Argo CD.

```
argocd --port-forward-namespace argocd app sync guestbook-gitops
```
</li>
<li>Verify the Sync policy from the ArgoCD UI.</li>
</ol>
</details>

### References
- https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/
