### Sync Policy & Options

#### Overview

-  Learn various sync Policy & Option provided by ArgoCD
    - auto-prune
    - auto-sync

#### Tasks

1. Edit  [manifest/ArgoCD101-GuestbookManifests/kustomization.yaml](https://github.com/argocon22Workshop/ArgoCDRollouts/blob/main/manifests/ArgoCD101-GuestbookApplicationManifests/kustomization.yaml#L5) comment out `service.yaml`
1. Commit the changes to your fork repo.
1. Login into ArgoCD using the user id `admin` and `password` (same credentials used in [exercise1][1]).
1. Go to the application and click on the `APP DIFF` button.
1. The service object marked in red needs to be pruned (deleted).
1. Select the sync with prune option, then apply the sync operation. After a successful  sync, the resource will be deleted.
1. The health of the application will be marked as  `green`, and the state of the application matches the desired state.

#### Optional Exercise

1. Using Argo CD cli, change the `guestbook` application to sync automatically

<details>
<summary>Click to view solution</summary>

<ul>
<li>Run the below commands:

```sh
argocd --port-forward-namespace argocd login
argocd --port-forward-namespace argocd app set guestbook  --sync-policy automated
```
</li>
<li>Verify the change applied in the application:

```sh
argocd --port-forward --port-forward-namespace argocd app get guestbook -o yaml
    Output:
                {
                    "automated": {}
                }

```
</li>
</ul>
</details>

2. The application can be configured with the various Sync options. Look for these options (Prune Last,Apply Out of Sync Only) in Argo CD UI and try to understand how it changes the sync process.

<details>
<summary>Click to view solution</summary>
<ol>
<li>Edit the application on the ArgoCD UI.</li>
<li>Select and Save the Sync option you want to enable in the application.</li>
<li>Usually in production, you will use CLI or add annotation to your Gitops application manifest.</li>
</ol>
</details>

### References
- https://argo-cd.readthedocs.io/en/stable/user-guide/sync-option
- https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/#automated-sync-semantics
- https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/#automatic-pruning

[1]: exercise1.md
