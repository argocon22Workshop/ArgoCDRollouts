### Declarative Setup (GitOps)

Argo CD applications, projects and settings can be defined declaratively using Kubernetes manifests. Argo CD comes with its own crd that can be stored in github repo, and applied in a target cluster using kubectl or  using Argo CD.
To setup declarative, you need to define the Application manifest, which uses your source repo.


1. Edit [manifest/ArgoCD101-GuestbookGitOps/guestbook_application.yaml](https://github.com/argocon22Workshop/ArgoCDRollouts/blob/main/manifests/ArgoCD101-GuestbookGitOps/guestbook_application.yaml) replace with your Github username that you forked the repo too.
1. Deploy the app using Application manfest using the user id `admin` and `password`.
    ```
    Delete any app with the name guestbook. The app will be recreated using the Application manifest file.
    argocd --port-forward --port-forward-namespace argocd app delete guestbook --cascade

    kustomize build manifests/ArgoCD101-GuestbookGitOps/ | kubectl apply -f -
    argocd --port-forward --port-forward-namespace argocd login
    argocd --port-forward --port-forward-namespace argocd app sync guestbook
    ```
1.  Optional Exercise:
    -   Add Sync policy to the application manifest?
            <details>
            <summary>Click to view solution</summary>

            1. Add the below spec to  manifests/ArgoCD101-GuestbookGitOps/guestbook_application.yaml
                    # Sync policy
                    syncPolicy:
                        automated:
                        prune: true
                        selfHeal: true
                        allowEmpty: false
            2. Commit the change to your own fork repo.
            3. Apply the new manifest to Argo CD.
                    kustomize build manifests/ArgoCD101-GuestbookGitOps/ | kubectl apply -f -
                    argocd --port-forward --port-forward-namespace argocd login
                    argocd --port-forward --port-forward-namespace argocd app sync guestbook
            4. Verify the Sync policy from the ArgoCD UI.