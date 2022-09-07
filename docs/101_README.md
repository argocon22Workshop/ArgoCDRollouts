##
1. Prerequisites Setup

    For the 101 session we will require Docker for Desktop with Kubernetes Enabled, and homebrew installed.

    You can install Docker for Desktop by following the instructions on the [Docker for Desktop](https://docs.docker.com/get-started/#download-and-install-docker) page.

    You can install homebrew via the following command:

    ```
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

    You can check your setup by running the precheck script found at `scripts/prereq-check.sh` of this repo.

1.  Argo CD installation


    ### Setup Argo CLI Tools
    #### OSX
    ```bash
    brew install argocd
    brew install argoproj/tap/kubectl-argo-rollouts
    ```

    ### Setup ArgoCD
    ```
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    ```
    #### Username: `admin` Password: `run command below`
    ```
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    ```
    #### Access UI
    Run the following command to access the UI in a new terminal window:

    ```
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```
    Visit the UI at `http://localhost:8080`.



1. Setup guestbook application via GitOps

    Fork this repo first then replace `<username>` with your GitHub username in the commands below.
    ```
    argocd --port-forward --port-forward-namespace argocd login
    argocd --port-forward --port-forward-namespace argocd repo add https://github.com/<username>/ArgoCDRollouts
    argocd --port-forward --port-forward-namespace argocd app create guestbook --repo https://github.com/<username>/ArgoCDRollouts --path manifests/ArgoCD101-GuestbookApplicationManifests --dest-namespace default --dest-server https://kubernetes.default.svc
    argocd --port-forward --port-forward-namespace argocd app sync guestbook
    ```

1. ArgoCD Exercises:
    - Exercises is based on Argo CD and Gitops concepts. The purpose of this is to familiarize you with the  interface of ArgoCD & Argo CLI.
        - [Task 1](Task-101-ArgoCD/task1.md) -  GitOps
        - [Task 2](Task-101-ArgoCD/task2.md) -  Sync Policy & Options
        - [Task 3](Task-101-ArgoCD/task3.md)  - Declarative-setup

1. Setup Argo Rollouts Controller
    ```
    kubectl create namespace argo-rollouts
    kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

    ```
    `You can now view and sync the application at: https://localhost:8080/applications/argo-rollouts`

1. Deploy Argo Rollouts Demo App via UI

    1. Click on the  `New App`![main](../assets/mainscreen.jpg)
    1. Fill the application details ![screen2](../assets/createapp-1.jpg)
    1. Click on the `Create` button  to create argo rollout application![screen3](../assets/createapp-2.jpg)

1. Argo Rollout Exercises
    - [Deployment Strategies](https://argoproj.github.io/argo-rollouts/concepts/#deployment-strategies)
        - [Task 1](Task-101-Rollouts/task1.md) - BlueGreen
        - [Task 2](Task-101-Rollouts/task2.md) - Canary
        ```
        BlueGreen enables the developers to run tests against the new version of the application before switching the live traffic over to the new version of the application, whereas canary deployment exposes a subset of users to the new version of the application while serving the rest of the traffic to the previous version.
        ```
1. ArgoCD and ArgoRollouts integrations
  [Custom Health Check](https://argo-cd.readthedocs.io/en/stable/operator-manual/health/#custom-health-checks)
  - Define a Custom Health Check in argocd-cm ConfigMap
  - Contribute a Custom Health Check
    -  Predefined [HealthCheck](/)

#### Argocd Project documentation
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Argo Rollout](https://argoproj.github.io)
- [Application Set](https://argo-cd.readthedocs.io )