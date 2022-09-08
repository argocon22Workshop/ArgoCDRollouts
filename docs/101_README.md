1. Install prerequisites

    For the 101 session we will require Docker Desktop, Homebrew, and the Argo CLIs.

    1. Install Docker for Desktop by following the instructions on the [Docker Desktop](https://docs.docker.com/get-started/#download-and-install-docker) page.

    1. Install homebrew via the following command:

        ```sh
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ```
       
    1. Install the Argo CD and Argo Rollouts CLIs

        ```sh
        brew install argocd
        brew install argoproj/tap/kubectl-argo-rollouts
        ```

    1. Check the previous steps by running [`scripts/prereq-check.sh`](../scripts/prereq-check.sh) found in this repo.
    
1. Install Argo CD and log in

    ```sh
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    ```
    
    #### Retrieve the initial admin password

    ```sh
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    ```
   
    **Remember the password, as you will need it later in the workshop exercise.

    #### Load the UI

    Run the following command to access the UI in a new terminal window:

    ```sh
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```

    Visit the UI at [`https://localhost:8080`](https://localhost:8080).

    Log in with username `admin` and the password retrieved above.

1. Set up a simple test application

    Fork this repo first then replace `<username>` with your GitHub username in the first command below.

    ```sh
    USERNAME="<username>"
    argocd --port-forward --port-forward-namespace argocd login
    argocd --port-forward --port-forward-namespace argocd repo add "https://github.com/$USERNAME/ArgoCDRollouts"
    argocd --port-forward --port-forward-namespace argocd app create guestbook --repo "https://github.com/$USERNAME/ArgoCDRollouts" --path manifests/ArgoCD101-GuestbookApplicationManifests --dest-namespace default --dest-server https://kubernetes.default.svc
    argocd --port-forward --port-forward-namespace argocd app sync guestbook
    ```

1. Try some basic Argo CD tasks

   These exercises are based on Argo CD and GitOps concepts. The purpose of this is to familiarize you with the Argo CD UI and CLI.
   
   - [Task 1](Task-101-ArgoCD/task1.md) - Application Sync Status
   - [Task 2](Task-101-ArgoCD/task2.md) - Sync Policy & Options
   - [Task 3](Task-101-ArgoCD/task3.md) - Declarative Setup (GitOps)

1. Install Argo Rollouts

    ```sh
    kubectl create namespace argo-rollouts
    kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
    ```
   
    You can now view and sync the application at [https://localhost:8080/applications/argo-rollouts](https://localhost:8080/applications/argo-rollouts).

1. Deploy Argo Rollouts Demo App and Nginx Ingress Controller via UI

    1. Click on the `New App` button 
       ![main](../assets/mainscreen.jpg)
    1. Fill the application details 
       ![screen2](../assets/createapp-1.jpg)
    1. Click on the `Create` button  to create argo rollout application
       ![screen3](../assets/createapp-2.jpg)
    1. Click on the `Sync` button within the application to deploy
    
1. Do Argo Rollouts Exercises
    - [Deployment Strategies](https://argoproj.github.io/argo-rollouts/concepts/#deployment-strategies)
        - [Task 1](Task-101-Rollouts/task1.md) - BasicCanary Rollout
        > A canary rollout is a deployment strategy where the operator releases a new version of their application to a small percentage of the production traffic.

1. Check out Argo CD and Argo Rollouts integrations
    - [Custom Health Check](https://argo-cd.readthedocs.io/en/stable/operator-manual/health/#custom-health-checks)
    - [Custom Action](https://argo-cd.readthedocs.io/en/stable/operator-manual/resource_actions/#custom-resource-actions)
        - Define a Custom Health Check in argocd-cm ConfigMap
        - Contribute to resource customization
            - https://github.com/argoproj/argo-cd/tree/master/resource_customizations

#### Argocd Project documentation

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Argo Rollout](https://argoproj.github.io)
- [Application Set](https://argo-cd.readthedocs.io )