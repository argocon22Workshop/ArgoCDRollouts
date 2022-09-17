### Configure Users permissions to access Argo CD

#### Overview

Argo CD provides a integration with many identity providers to authenticate and authorize users to interact with the UI and the API. In this exercise we are going to create a local user with no permission and gradually grant access to certain features.

#### Exercises

1. Local users are defined in the main Argo CD configmap (`argocd-cm`). Run the following command to create a new user (`workshop`) in Argo CD:

```
  kubectl apply -n argocd -f manifests/ArgoCD201-ArgoCDRBAC/argocd-cm.yaml
```

2. We need to login with Argo CD CLI so we can manage our newly created user. First we need to retrieve the admin password with:

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
Then login with the following command:

```
argocd --port-forward --port-forward-namespace argocd login
```
For user enter: `admin`
For password enter the string returned in the `kubectl` command above

3. Now we need to change the password of the new user. The default password is the same as the one defined by Argo CD `admin` user.

Copy the same password used in step 2 and update the following command replacing the `ADMIN_PASSWORD` with it. Also update the new password replacing the `SOMETHING_SAFE` with something else (min 8 characters).

```
argocd --port-forward-namespace argocd account update-password --account workshop --current-password ADMIN_PASSWORD --new-password SOMETHING_SAFE
```

4. Let's verify if our new user is created successfully. In order to do so run the following command:
```
argocd --port-forward-namespace argocd account list
```

You should be able to see the output with something similar to:
```
NAME      ENABLED  CAPABILITIES
admin     true     login
workshop  true     apiKey, login
```

5. Login in [Argo CD UI](https://localhost:8080) using the `workshop` user using the new password defined by you in step 3. Once you login note that you can't see nor create anything using the [Argo CD UI](https://localhost:8080).
    ```sh
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    (To access the Argo CD ui, execute the above command)
    ```
6. Let's add readonly access to our new user. In order to do so edit the file in `manifests/ArgoCD201-ArgoCDRBAC/argocd-rbac-cm.yaml` and add the line `policy.default: role:readonly`. The file must look like in the example bellow:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/name: argocd-rbac-cm
    app.kubernetes.io/part-of: argocd
  name: argocd-rbac-cm
data:
  policy.default: role:readonly
  policy.csv: |
    g, workshop, role:workshop
```

Save the file and apply it using the following command:

```
kubectl apply -n argocd  -f manifests/ArgoCD201-ArgoCDRBAC/argocd-rbac-cm.yaml
```
#### Optional Exercise

Add a new permission for the user `workshop` allowing it to create projects

<details>
<summary>Click to view solution</summary>
<ol>
<li>Login with argocd CLI using the new `workshop` user with the following command:

```
argocd --port-forward --port-forward-namespace argocd login
```
</li>
<li>Try to create a project with the current permissions associated with the `workshop` user with:

```
argocd --port-forward-namespace argocd proj create testproject
```
The following error message should be returned from the command above:
```
FATA[0000] rpc error: code = PermissionDenied desc = permission denied: projects, create, testproject, sub: workshop
```
</li>
<li>Edit the file in `manifests/ArgoCD201-ArgoCDRBAC/argocd-rbac-cm.yaml` and add the line `p, role:workshop, projects, *, *, allow` below the `policy.csv` string. The file must look like in the example bellow:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/name: argocd-rbac-cm
    app.kubernetes.io/part-of: argocd
  name: argocd-rbac-cm
data:
  policy.default: role:readonly
  policy.csv: |
    p, role:workshop, projects, *, *, allow
    g, workshop, role:workshop
```
</li>
<li>Save the file and apply it using the following command:

```
  kubectl apply -n argocd  -f manifests/ArgoCD201-ArgoCDRBAC/argocd-rbac-cm.yaml
```
</li>
<li>Try to create an Argo CD project running the same command from step 2. No error should be returned this time.
<li>Navigate in Argo CD UI and see the newly created project listing under "Settings > Projects".</li>
</ol>
</details>
