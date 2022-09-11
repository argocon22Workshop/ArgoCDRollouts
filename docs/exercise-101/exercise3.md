### Application Sync Status

#### Overview

By default, Argo CD polls Git repositories every three minutes to detect changes to the manifests.
- Fetch the latest Git state from the repositories.
- Compare the desired state with the live state.

Argo CD Controller:
- If both states are the same, do nothing and mark the application as synced.
- If states are different mark the application as `OutOfSync`.

#### Exercises

1. Explore the manifest used in this task found [here](https://github.com/argocon22Workshop/ArgoCDRollouts/tree/main/manifests/ArgoCD101-GuestbookManifests).
1. Edit [manifest/ArgoCD101-GuestbookManifests/deployment.yaml](https://github.com/argocon22Workshop/ArgoCDRollouts/blob/main/manifests/ArgoCD101-GuestbookManifests/deployment.yaml) change the replica count to 3.
1. Commit the change to your own fork repo.
1. Login into ArgoCD UI using the user id `admin` and `password` (same credentials used in [exercise1][1])
1. Go to the Argo CD application and  click on the `APP DIFF` button.
1. Take a note of the differences in the ArgoCD application, app will be OutOfSync. The replica count is changed to 3.
1. Click on  `SYNC` button (Select the default options and synchronize all manifests) on the  application UI to apply the desired manifest.
1. Once it's deployed, Application is marked as healthy and the number of pods will increased to 3.

#### Optional Exercise

Update the replica count to one without making any changes to the source code of Git?

<details>
<summary>Click to view solution</summary>
    <ol>
    <li>In the ArgoCD UI, click on `deploy` resource. Edit the `live manifest` and set the replica count to one and save it.</li>
    <li>A total of 2 pods will terminate and the application will be marked out of sync.</li>
    </ol>
</details>

[1]: exercise1.md
