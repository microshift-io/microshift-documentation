---
modified: "2021-11-03T16:31:13.096+01:00"
---

# MicroShift

MicroShift is a research project that is exploring how OpenShift and Kubernetes can be optimized for small form factor and edge computing.

This repository contains the files required for building the documentation at <https://microshift.io>

### Pulling Container Image From Private Registries

MicroShift may not have the pull secret for the registry that you are trying to use. For example, MicroShift does not have the pull secret for `registry.redhat.io`. In order to use this registry, there are several approaches. The first approach is to use `podman login`,

```sh
podman login registry.redhat.io
```

Once the podman login is complete, MicroShift will be able to pull images from this registry. This approach works across name spaces.

This approach assumes podman is installed. This might not be true for all MicroShift environments. For example, if MicroShift is installed through RPM, CRI-O will be installed as dependency, but no podman. In this case, one can choose to install podman separately, or use other approaches described below.

The second approach is to create a pull secret, then let the service account to use this pull secret. This approach works within a name space. For example, if the pull secret is stored in a json formatted file "secret.json",

```sh
# First create the secret in a name space
kubectl create secret generic my_pull_secret \
    --from-file=secret.json \
    --type=kubernetes.io/dockerconfigjson
# Then attach the secret to a service account in the name space
kubectl secrets link default my_pull_secret --for=pull
```

Instead of attaching the secret to a service account, one can also specify the pull secret under the pod spec, Refer to [this Kubernetes document](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) for more details.

### Contributing

For more information on working with MicroShift, you can find a contributor's guide in [`CONTRIBUTING.md`](./CONTRIBUTING.md)

### Community

Join us on [Slack](https://microshift.slack.com)! ([Invite to the Slack space](https://join.slack.com/t/microshift/shared_invite/zt-uxncbjbl-XOjueb1ShNP7xfByDxNaaA))

Community meetings are held weekly, Wednesdays at 10:30AM - 11:00AM EST. Be sure to join the community [calendar](https://calendar.google.com/calendar/embed?src=nj6l882mfe4d2g9nr1h7avgrcs%40group.calendar.google.com&ctz=America%2FChicago)! Click "Google Calendar" in the lower right-hand corner to subscribe.
