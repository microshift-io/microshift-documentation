---
title: MicroShift with Advanced Cluster Management
weight: 8
summary: MicroShift with ACM
draft: true
modified: "2021-11-10T11:40:58.922+01:00"
---

## MicroShift with Advanced Cluster Management
Red Hat Advanced Cluster Management(RHACM) can be used to manage the lifecycle of applications running on MicroShift. Currently, this functionality is only available for AMD64 based systems. In future releases of RHACM, management functionality of applications running on MicroShift will be available on ARM based architectures.

The steps below assume that RHACM has been installed on a cluster and that MicroShift is installed on a separate cluster.

Two variations of importing the MicroShift cluster will be described.

### Non-routable MicroShift cluster
Depending on the networking configurations that may be used access to the MicroShift cluster from RHACM using a FQDN may not be possible. In this case, the MicroShift cluster can be imported using the following steps:

On the RHACM cluster, run the following command to import the MicroShift cluster:

NOTE: Ensure you set the cluster name to a unique value that relates to the MicroShift cluster.
```
export CLUSTER_NAME=microshift
oc new-project ${CLUSTER_NAME}
oc label namespace ${CLUSTER_NAME} cluster.open-cluster-management.io/managedCluster=${CLUSTER_NAME}

cat <<EOF | kubectl apply -f -
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
  version: 2.2.0
EOF

cat <<EOF | kubectl apply -f -
apiVersion: cluster.open-cluster-management.io/v1
kind: ManagedCluster
metadata:
  name: ${CLUSTER_NAME}
spec:
  hubAcceptsClient: true
EOF

```
This will generate a secret named ${CLUSTER_NAME}-import in the ${CLUSTER_NAME} namespace.

### Routable MicroShift cluster
If the MicroShift cluster is routable by the RHACM cluster, the following steps can be used to import the cluster:

On the RHACM cluster, run the following command to import the MicroShift cluster:
```
oc new-project ${CLUSTER_NAME}
oc label namespace ${CLUSTER_NAME} cluster.open-cluster-management.io/managedCluster=${CLUSTER_NAME}
```

Using the Kubeconfig of the MicroShift cluster, the following command can be used to import the cluster:
```
export KUBECONFIG_IMPORT=`cat kubeconfig | base64 -w0`

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  namespace: spoke
  name: auto-import-secret
data:
  autoImportRetry: NQo=
  kubeconfig: |-
    ${KUBECONFIG_IMPORT}
EOF

cat <<EOF | kubectl apply -f -
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
  version: 2.2.0
EOF

cat <<EOF | kubectl apply -f -
apiVersion: cluster.open-cluster-management.io/v1
kind: ManagedCluster
metadata:
  name: ${CLUSTER_NAME}
spec:
  hubAcceptsClient: true
EOF
```

Once these objects have been created the RHACM cluster will be able to connect to the MicroShift cluster.
