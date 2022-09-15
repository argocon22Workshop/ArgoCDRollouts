### Exercise 5: Deploying an Application with GitOps

#### Overview

Argo CD applications, projects and settings can be defined declaratively using Kubernetes manifests. Argo CD comes with its own crd that can be stored in GitHub repo, and applied in a target cluster using kubectl or using Argo CD.
To set up declaratively, you need to define the Application manifest, which uses your source repo.

#### Steps

1. Delete any app with the name guestbook. The app will be recreated using the Application manifest file.
    ```sh
    argocd --port-forward-namespace argocd app delete guestbook --cascade
    ```
1. Edit the file in `manifests/ArgoCD101-GuestbookGitOps/guestbook_application.yaml` and replace the `<username>` with your GitHub username that you used to fork the repo.
1. Commit the changes and push to the main branch of your forked repo.
1. Deploy the app using Application manifest using the user id `admin` and `password`.

    ```sh
    argocd --port-forward --port-forward-namespace argocd login
    argocd --port-forward-namespace argocd app create guestbook-gitops --repo "https://github.com/$WORKSHOP_USER/ArgoCDRollouts" --path manifests/ArgoCD101-GuestbookGitOps --dest-namespace default --dest-server https://kubernetes.default.svc
    ```

1. Sync the application

    ```sh
    argocd --port-forward-namespace argocd app sync guestbook-gitops
    ```

#### Optional Step

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
<li>Verify the Sync policy from the Argo CD UI.</li>
</ol>
</details>

### References
- https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/
