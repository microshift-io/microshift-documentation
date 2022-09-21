---
title: MicroShift with Advanced Cluster Management
weight: 9
summary: MicroShift with ACM
tags:
  - ACM
  - GitOps
  - RHACM
description: Manage the MicroShift cluster through Red Hat Advanced Cluster Management (RHACM).
draft: false
modified: "2021-11-30T12:40:37.755+01:00"
---

## MicroShift with Advanced Cluster Management
Managing through RHACM (Red Hat Advanced Cluster Management) works just like for any other imported managed cluster (see [docs]). However, as secure production deployments don't provide any form of remote access to the cluster via ssh or kubectl, the recommended approach is to define a new cluster with ACM to get managed cluster credentials, then using your device (configuration) management agent of your choice to synchronise those credentials to the device and have MicroShift apply them automatically.

The feature of using RHACM to manage the lifecycle of applications running on MicroShift is only available for AMD64 based systems. Starting with RHACM 2.5, the management functionality of applications running on MicroShift will be available on ARM based architectures.

The steps below assume that RHACM has been installed on a cluster recognized as the hub cluster and that MicroShift is installed on a separate cluster referred to as the managed cluster.

### Defining the managed cluster in hub cluster
The following steps can be performed in the RHACM UI or on the CLI. On the RHACM hub cluster, run the following commands to define the MicroShift cluster as the managed cluster:

NOTE: Ensure you set the CLUSTER_NAME to a unique value that relates to the MicroShift cluster.
```
export CLUSTER_NAME=microshift

oc new-project ${CLUSTER_NAME}

oc label namespace ${CLUSTER_NAME} cluster.open-cluster-management.io/managedCluster=${CLUSTER_NAME}
```

Apply the following to define the managed MicroShift cluster.
```
cat <<EOF | oc apply -f -
apiVersion: agent.open-cluster-management.io/v1
kind: KlusterletAddonConfig
metadata:
  name: ${CLUSTER_NAME}
  namespace: ${CLUSTER_NAME}
spec:
  clusterName: ${CLUSTER_NAME}
  clusterNamespace: ${CLUSTER_NAME}
  applicationManager:
    enabled: true
  certPolicyController:
    enabled: true
  clusterLabels:
    cloud: auto-detect
    vendor: auto-detect
  iamPolicyController:
    enabled: true
  policyController:
    enabled: true
  searchCollector:
    enabled: true
EOF

cat <<EOF | oc apply -f -
apiVersion: cluster.open-cluster-management.io/v1
kind: ManagedCluster
metadata:
  name: ${CLUSTER_NAME}
spec:
  hubAcceptsClient: true
EOF

```

This will generate a secret named ${CLUSTER_NAME}-import in the ${CLUSTER_NAME} namespace. Extract the `import.yaml` and the `crds.yaml` which requires `yq` to be installed.

```
IMPORT=$(oc get secret "$CLUSTER_NAME"-import -n "$CLUSTER_NAME" -o jsonpath={.data.import\\.yaml} | base64 --decode)
IMPORT_KUBECONFIG=$(yq eval-all '. | select(.metadata.name == "bootstrap-hub-kubeconfig") | .data.kubeconfig' IMPORT)
```

### Importing the managed Microshift cluster to hub cluster
The importing process can be done automatically by RHACM components running on the hub cluster once the following steps are performed on managed MicroShift cluster. A detailed explanation can be found in [RHACM documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.4/html/clusters/managing-your-clusters#importing-the-cluster-manual).

#### Prepare the manifests
A list of the K8s manifests based on [Kustomize](https://kustomize.io/) can be found in [this repo](https://github.com/redhat-et/microshift-documentation/content/en/docs/examples/manifests). This repo contains more than manifests however we will only focus on the `manifests` folder. Before syncing the manifests to the MicroShift node, the following commands need to be run to render manifests:
```
sed -i "s/{{ .clustername }}/${CLUSTER_NAME}/g" manifests/klusterlet.yaml
sed -i "s/{{ .kubeconfig }}/${IMPORT_KUBECONFIG}/g" manifests/klusterlet-kubeconfighub.yaml
```

#### Sync manifests to MicroShift node
The next step is to sync manifests to the MicroShift node. MicroShift has the feature of [auto-applying manifests](https://microshift.io/docs/user-documentation/manifests/). Once it finds a `kustomization.yaml` file in `${DATADIR}/manifests` (which defaults to `/var/lib/microshift/manifests`), `kubectl apply -k` will be run automatically upon start-up. The rendered manifests then need to be synced to `${DATADIR}/manifests`.

The syncing of manifests to managed Microshift cluster can be done by utilizing any GitOps tool to fetch the Kubernetes Kustomize manifests and put them in the directory described above, e.g. [Transmission](https://github.com/redhat-et/transmission) tool can be used to pull updates and apply them transactionally on the ostree-based Linux operating systems.

#### MicroShift auto-applies those manifests to register with the ACM cluster
The cluster now should have all add-ons enabled and be in a READY state within RHACM.
