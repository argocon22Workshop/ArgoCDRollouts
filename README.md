# ArgoCon 2022 Instructions

## Prerequisites Setup

For the 101 session we will require Docker for Desktop with Kubernetes Enabled installed.

You can install Docker for Desktop by following the instructions on the [Docker for Desktop](https://docs.docker.com/get-started/#download-and-install-docker) page.

You can check your setup by running the precheck script found in the `scripts` directory of this repo.

``
## Setup Argo CLI Tools

### OSX
```bash
brew install argocd
brew install argoproj/tap/kubectl-argo-rollouts
```