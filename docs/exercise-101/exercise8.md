### Exercise 8: Trying Deployment Strategies

Argo Rollouts supports different deployment strategies such as:

- Blue-green deployments
- Canary deployments

Check the main Argo Rollouts documentation to learn more about the
supported [deployment strategies][1]

In this exercise we will deploy an application using the canary strategy

     > A canary rollout is a deployment strategy where the operator
     > releases a new version of their application to a small percentage
     > of the production traffic.

#### Trigger rollout by modifying the image to red

1. Within your forked repo navigate to the `manifests/ArgoCD101-RolloutsDemoApp/canary.yaml` file and edit the
image to `ghcr.io/argocon22workshop/rollouts-demo:red` and commit the change and push.
2. Navigate to the Argo CD UI and sync the `rollouts-demo` application.
3. Navigate to the Argo Rollouts Demo App UI at http://localhost:81/.
4. Observe the change in the UI. Notice we now see about 20% red pixels. This is due to the steps defined in the
rollout which is shown below:
    ```yaml
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
6. Go into the Argo CD UI and look for the rollout resource you will see the three vertical dots you can click.
Under that menu there will be a `resume` option click that and then go watch the rollouts demo app as it gradually increases
traffic to the canary.

[1]: https://argoproj.github.io/argo-rollouts/concepts/#deployment-strategies

7. Once you have completed the exercise you can delete the application by clicking on the `Delete` button in the Argo CD UI.
