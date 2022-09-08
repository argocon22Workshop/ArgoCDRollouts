### 1. Modify the image to red

1. Within your forked repo navigate to the `manifests/ArgoCD101-RolloutsDemoApp/canary.yaml` file and edit the 
image to `ghcr.io/argocon22workshop/rollouts-demo:red` and commit the change and push.
2. Navigate to the Argo CD UI and sync the `rollouts-demo` application.
3. Navigate to the Argo Rollouts Demo App UI at http://localhost:81/.
4. Observe the change in the UI. Notice we now see about 20% red pixels. This is due to the steps defined in the 
rollout which is shown below:
    ```
      steps:
        - setWeight: 20
        - pause: {}
        - setWeight: 40
        - pause: {duration: 10}
        - setWeight: 60
        - pause: {duration: 10}
        - setWeight: 80
        - pause: {duration: 10}
    ```
5. You will notice that the second step is `pause: {}` which means that the rollout will pause at 20% of the traffic until
we manually unpause the rollout. We will do this in the next step.
6. 