---
title: Auto-applying Manifests
tags:
  - manifests
  - kustomize
draft: False
weight: 40
card:
  name: user-documentation
  weight: 40
description: Automatically applying manifests for bootstrapping cluster services.
---
A common use case after bringing up a new cluster is applying manifests for bootstrapping a [management agent like the Open Cluster Management's klusterlet]({{< ref "/docs/user-documentation/how-tos/acm-with-microshift" >}}) or for starting up services when running disconnected.


MicroShift leverages [`kustomize`](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/) for Kubernetes-native templating and declarative management of resource objects. Upon start-up, it searches `/etc/microshift/manifests`, `/usr/lib/microshift/manifests` and
`${DATADIR}/manifests` (which defaults to `/var/lib/microshift/manifests`) for a `kustomization.yaml` file. If it finds one, it automatically runs `kubectl apply -k` to that kustomization`

Example:
```
cat <<EOF >/etc/microshift/manifests/nginx.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: NGINX_IMAGE
        ports:
        - containerPort: 8080
EOF

cat <<EOF >/etc/microshift/manifests/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - nginx.yaml
images:
  - name: NGINX_IMAGE
    newName: nginx:1.21
EOF
```

The reason for providing multiple directories is to allow a flexible method to manage
MicroShift workloads.

| Location   	                    | Intent  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	|
|---------------------------------|-------------------------------------------------------------------------------|
| `/etc/microshift/manifests`     | R/W location for configuration management systems or development              |
| `/usr/lib/microshift/manifests` | RO location, for embedding configuration manifests on ostree based systems  	|
| `${DATADIR}/manifests`   	      | R/W location for backwards compatibility (deprecated)                         |

The list of manifest locations can be customized via configuration using the manifests section (see
[here](https://github.com/openshift/microshift/blob/main/test/config.yaml)) or via the `MICROSHIFT_MANIFESTS`
environment variable as comma separated directories.