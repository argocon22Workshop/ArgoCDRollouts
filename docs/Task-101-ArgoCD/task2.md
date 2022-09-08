### Sync Policy & Options
-  Learn various sync Policy & Option provided by ArgoCD:
    - auto-prune
    - auto-sync
    - self-heal

1. Edit  [manifest/ArgoCD101-GuestbookManifests/kustomization.yaml](https://github.com/argocon22Workshop/ArgoCDRollouts/blob/main/manifests/ArgoCD101-GuestbookApplicationManifests/kustomization.yaml#L5) comment out `service.yaml`
1. Commit the changes to your fork repo.
1.  Login into ArgoCD using the user id `admin` and `password`.
    1. Go to the application and click on the `APP DIFF` button.
    1.  The service object marked in red needs to be pruned (deleted).
    1. Select the sync with prune option, then apply the sync operation.
    1. The health of the application will be `green`, and the state of the application matches the desired state.
    1.  Optional Exercise:

        - Apply automate sync to the `guestbook` application using Argo CD CLI?
                <details>
                <summary>Click to view solution</summary>

                    1. Run the below commands
                            argocd --port-forward --port-forward-namespace argocd login
                            argocd --port-forward --port-forward-namespace argocd app set guestbook  --sync-policy automated \
                    2. argocd --port-forward --port-forward-namespace argocd app get guestbook -o json |jq .spec.syncPolicy.
                        Output:
                                    {
                                        "automated": {}
                                    }
                    If you don't have jq install, check for the above output in your json response.

        - The application can be configured with the various Sync options. Look for these options (Prune Last,Apply Out of Sync Only) on the UI?
                <details>
                <summary>Click to view solution</summary>
                    1. Edit the application on the ArgoCD UI. \
                    2. Select and Save the Sync option you want to enable in the application. \
                    3. Usually in production, you will use CLI or add annotation to your Gitops application manifest. \
                    4. [Sync Option documentation](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-option/) \
                    </details>
- https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/#automated-sync-semantics
