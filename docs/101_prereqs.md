## 1. Workshop 101 Prerequisites

For the 101 session we will require:

- Docker Desktop
- Homebrew
- Argo CLIs.

You will also need to fork and clone this repo.

### 1.1 Install Docker Desktop

Install Docker for Desktop by following the instructions on the [Docker Desktop](https://docs.docker.com/get-started/#download-and-install-docker) page.

Open the Docker settings after the installation is completed, and enable Kubernetes cluster.

### 1.2 Install Homebrew

If you don't have Homebrew already available you can install it via the following command:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
 ```
### 1.3 Verify the Github access

Throughout the exercise, you will push the local changes to your forked repo using Github Access. Ensure that you have an active Github account, and have setup git access in your local computer.

If you do not have a Github account, please refer to the  [Github documentation](https://docs.github.com/en/get-started/onboarding/getting-started-with-your-github-account) for information on how to create an account.

### 1.4 Install Argo CD and Argo Rollouts CLIs

To install Argo CD and Argo Rollouts CLIs, run the following commands:

```sh
brew install argocd
brew install argoproj/tap/kubectl-argo-rollouts
```
### 1.5 Fork this repo

1. Fork [this repo](https://github.com/argocon22Workshop/ArgoCDRollouts) by clicking that link and then clicking the
   "Fork" button near the top-right of the GitHub page.

2. Clone the forked repo.

   ```sh
   WORKSHOP_USER=<your GitHub username here>
   git clone "https://github.com/$WORKSHOP_USER/ArgoCDRollouts.git"
   ```

### 1.6 Verify installation

Using your terminal, navigate to the root of the clone and run this script to check if the prereqs are met.

    ```sh
    cd ArgoCDRollouts && bash scripts/prereq-check.sh
    ```
