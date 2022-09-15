### Exercise 3: Understanding Application Sync Status

#### Overview

By default, Argo CD polls Git repositories every three minutes to detect changes to the manifests.
- Fetch the latest Git state from the repositories.
- Compare the desired state with the live state.

Argo CD Controller:
- If both states are identical, do nothing and mark the application as synced..
- If states are different mark the application as `OutOfSync`.

#### Steps

1. Edit the file in  `manifests/ArgoCD101-GuestbookManifests/deployment.yaml` change the replica count to 3.
1. Commit the changes and push to the main branch of your forked repo.
1. Login into Argo CD UI using the user id `admin` and `password` (same credentials used in [exercise 1][1])
1. Take a note of the differences in the ArgoCD application manifest,  app will be OutOfSync (It might take a few minutes for the OutofSync status to appear).
1. If you click the `APP DIFF` button in the Argo CD application, you will see that the replica count has changed to 3.
1. Click on  `SYNC` button (Select the default options and synchronize all manifests) on the  application UI to apply the desired manifest.
1. Once it's deployed, Application is marked as healthy and the number of pods will be increased to 3.

#### Optional Step

Update the replica count to one without making any changes to the source code of Git?

<details>
<summary>Click to view solution</summary>
    <ol>
    <li>In the ArgoCD UI, click on `deploy` resource. Edit the `live manifest` and set the replica count to one and save it.</li>
    <li>A total of 2 pods will terminate and the application will be marked out of sync.</li>
    </ol>
</details>

[1]: exercise1.md
