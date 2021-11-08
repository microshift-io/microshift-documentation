---
title: Working With Private Registries
tags:
  - registry
  - registries
  - pull-secret
  - podman
draft: false
weight: 9
summary: MicroShift may need access to a private registry. Access can be granted from registry login or from a pull-secret.
modified: "2021-11-05T16:27:17.880+01:00"
---

MicroShift may not have the pull secret for the registry that you are trying to use. For example, MicroShift does
not have the pull secret for `registry.redhat.io`. In order to use this registry, there are a few approaches.

### Pulling Container Images From Private Registries

#### Use Podman to Authenticate to a Registry

```sh
podman login registry.redhat.io
```

Once the podman login is complete, MicroShift will be able to pull images from this registry. This approach works across namespaces.

This approach assumes podman is installed. This might not be true for all MicroShift environments. For example,
if MicroShift is installed through RPM, CRI-O will be installed as a dependency, but not podman. In this case,
one can choose to install podman separately, or use other approaches described below.

#### Authenticate to a Registry With a Pull-Secret

The second approach is to create a pull secret, then let the service account use this pull secret. This approach works within a name space. For example, if the pull secret is stored in a json formatted file "secret.json",

```sh
# First create the secret in a name space
kubectl create secret generic my_pull_secret \
    --from-file=secret.json \
    --type=kubernetes.io/dockerconfigjson
# Then attach the secret to a service account in the name space
kubectl secrets link default my_pull_secret --for=pull
```

Instead of attaching the secret to a service account, one can also specify the pull secret under the pod spec, Refer to [this Kubernetes document](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) for more details.
