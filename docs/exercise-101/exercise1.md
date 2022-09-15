### Exercise 1: Installing Argo CD

In this exercise we will install Argo CD and login to the UI.

#### 1.1. Install Argo CD manifests

```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

#### 1.2. Retrieve the initial admin password

```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
** If above command fails, wait for 1-2 minutes and run it again and save the password somewhere, as you will need it later in the workshop exercise.

#### 1.3. Load the UI

Run the following command to access the UI in a new terminal window:

```sh
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Visit the UI at [`https://localhost:8080`](https://localhost:8080).

Log in with username `admin` and the password retrieved above.
