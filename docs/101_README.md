# Argo CD / Rollouts Workshop 101

## 1. Workshop prerequisites

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
Please refer to the [Github documentation](https://docs.github.com/en/get-started/onboarding/getting-started-with-your-github-account) for information on how to create an account.

### 1.4 Install Argo CD and Argo Rollouts CLIs

To install Argo CD and Argo Rollouts CLIs, run the following commands:

```sh
brew install argocd
brew install argoproj/tap/kubectl-argo-rollouts@1.3
```
### 1.5 Fork this repo

1. Fork [this repo](https://github.com/argocon22Workshop/ArgoCDRollouts) by clicking that link and then clicking the
   "Fork" button near the top-right of the GitHub page.

2. Clone the forked repo.

   ```sh
   WORKSHOP_USER=<your GitHub username here>
   git clone "https://github.com/$WORKSHOP_USER/ArgoCDRollouts.git"
   ```

3. Verify installation
      Using your terminal, navigate to the root of the clone and run this script to check if the prereqs are met.
      ```sh
      cd ArgoCDRollouts && bash scripts/prereq-check.sh
      ```
## 2. Exercises

### ArgoCD Exercises

These exercises are based on Argo CD and GitOps concepts. The purpose of this is to familiarize you with the Argo CD UI and CLI.

- [Exercise 1](exercise-101/exercise1.md) - Install Argo CD
- [Exercise 2](exercise-101/exercise2.md) - Using Argo CD CLI
- [Exercise 3](exercise-101/exercise3.md) - Application Sync Status
- [Exercise 4](exercise-101/exercise4.md) - Sync Policy & Options
- [Exercise 5](exercise-101/exercise5.md) - Deploy an Application with Gitops

### ArgoRollouts Exercises

- [Exercise 6](exercise-101/exercise6.md) - Install Argo Rollouts
- [Exercise 7](exercise-101/exercise7.md) - Deploy Argo Rollouts Demo App
- [Exercise 8](exercise-101/exercise8.md) - Deployment Strategies

## 3. References

### Argo CD / Rollouts Project documentation

- [Argo CD Documentation](https://argo-cd.readthedocs.io/)
- [Argo Rollout](https://argoproj.github.io)
- [ApplicationSets](https://argo-cd.readthedocs.io/en/stable/user-guide/application-set/)
