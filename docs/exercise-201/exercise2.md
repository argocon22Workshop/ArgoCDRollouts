### Creating Applications dynamically with ApplicationSets

#### Overview

Sometimes you want to create a lot of Applications based on some dynamic source of truth. You could create an 
[App of Apps](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#app-of-apps), a pipeline
to update the Apps, and a trigger to start the pipeline. Or you could let 
[ApplicationSets](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/) do the work for you.

ApplicationSet is a CRD which describes how to create Applications. The CRD includes an Application template and an
area to define the source of truth. ApplicationSets support several sources of truth through a variety of 
[generators](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators/).

The ApplicationSets manifests (CRD, operator, etc.) are bundled with Argo CD. If you are running a recent version of 
Argo CD, then you already have the ability to use ApplicationSets.

#### 1. Create a minimal project for the new Applications

It's important to use limited projects whenever possible. We'll install a project that can _only_ deploy Deployments, 
ReplicaSets, and Pods the the `default` namespace in the local cluster. We'll also allow-list only one source repo.

Keep in mind that it's [not currently safe](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Security/)
(as of Argo CD 2.4) to allow non-admins to install or modify ApplicationSets. The project's limitations do no good if 
the user can simply edit the ApplicationSet to use a different project.

1. (Optional) Change `crenshaw-dev` in [manifest/ArgoCD201-ApplicationSets/project.yaml](../../manifests/ArgoCD201-ApplicationSets/project.yaml) to your GitHub username.
   (If you make this change, you will also need to edit the ApplicationSet's `spec.template.spec.source.repoURL` field in the next step.)

2. Apply the project manifest to the `argocd` namespace.

   ```sh
   kubectl apply -n argocd -f manifests/ArgoCD201-ApplicationSets/project.yaml
   ```
   
#### 2. Create a personal access token

The ApplicationSet controller makes a lot of GitHub API requests. To avoid hitting the rate limit, use an API token.

1. Go to [New personal access token](https://github.com/settings/tokens/new) on GitHub.

2. Use the following details:

   Name: `ApplicationSet`
   
   Expiration: `7 days`

   Select scopes: `public_repo` (only this one)

3. Click "Generate token" and copy the token into your clipboard

4. Create a new Secret to hold the token

```sh
github_token=$(pbpaste)
echo '{"apiVersion": "v1", "kind": "Secret", "metadata": {"name": "github-token"}, "stringData": {"token": "'$github_token'"}}' | kubectl apply -n argocd -f - 
```
   
#### 3. Install the ApplicationSet

1. (Optional) Change `crenshaw-dev` in the `spec.template.spec.source.repoURL` field of [manifest/ArgoCD201-ApplicationSets/appset.yaml](../../manifests/ArgoCD201-ApplicationSets/appset.yaml) to your GitHub username. (Only do this if you also did so in section 1.)

2. Change `crenshaw-dev` in the `spec.generators[0].pullRequest.github.owner` field of [manifest/ArgoCD201-ApplicationSets/appset.yaml](../../manifests/ArgoCD201-ApplicationSets/appset.yaml) to your GitHub username.

3. Apply the ApplicationSet manifest to the `argocd` namespace.

   ```sh
   kubectl apply -n argocd -f manifests/ArgoCD201-ApplicationSets/appset.yaml
   ```

4. Confirm that the ApplicationSet was applied.

   ```sh
   kubectl get appset -n argocd
   ```

#### 4. List Applications under the `appsets` project

```shell
argocd app list --project appset
```

The list should be empty. Since you don't have any open PRs in your repo, the ApplicationSet's generator will not
produce any parameters, and the Application template in the ApplicationSet will be applied to the cluster zero times.

#### 5. Open a PR in your fork of `ArgoCDRollouts`

```sh
git checkout -b my-test-branch
git add manifests/*
git commit -m "edit manifests"
git push --set-upstream origin
```

The last command should print a link which you can use to open a PR.

Be sure to open the PR **against your fork**. By default, it will open against the original repo.

Add a label called `preview` to your PR. The [appset](../../manifests/ArgoCD201-ApplicationSets/appset.yaml) filters
by that label.

### 6. List Applications again

```shell
argocd app list --project appset
```

The list should contain an Application corresponding to your new PR.

To create more Applications, create new PRs.

```sh
git checkout -b another-branch
git push --set-upstream origin
```

Leave the `preview` label off a PR to show that the ApplicationSet's filter is working.
