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
Red Hat Advanced Cluster Management(RHACM) can be used to manage the lifecycle of applications running on MicroShift. Currently, this functionality is only available for AMD64 based systems. In future releases of RHACM, management functionality of applications running on MicroShift will be available on ARM based architectures.

The steps below assume that RHACM has been installed on a cluster and that MicroShift is installed on a separate cluster.

### Defining the cluster
The following steps can be performed in the RHACM UI or on the CLI by following steps defined below. On the RHACM cluster, run the following command to import the MicroShift cluster:

NOTE: Ensure you set the cluster name to a unique value that relates to the MicroShift cluster.
```
export CLUSTER_NAME=microshift

oc new-project ${CLUSTER_NAME}

oc label namespace ${CLUSTER_NAME} cluster.open-cluster-management.io/managedCluster=${CLUSTER_NAME}
```

Apply the following to define the Cluster.
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
  version: 2.2.0
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

This will generate a secret named ${CLUSTER_NAME}-import in the ${CLUSTER_NAME} namespace. Extract the import.yaml and the crds.yaml.

```
IMPORT=`oc get -n ${CLUSTER_NAME} secret ${CLUSTER_NAME}-import -o jsonpath='{.data.import\.yaml}'`
CRDS=`oc get -n ${CLUSTER_NAME} secret ${CLUSTER_NAME}-import -o jsonpath='{.data.crds\.yaml}'`
```

### Importing the cluster
From the MicroShift cluster run the following command to import the cluster into RHACM.

```
echo $CRDS | base64 -d | oc apply -f -
echo $SECRET | base64 -d | oc apply -f -
```

To correctly deploy the images a secret must be added and service accounts must be patched to allow access to the images. To begin create secret to access registry.redhat.io.

```
podman login registry.redhat.io --authfile=~/auth.json
oc create secret generic rhacm -n open-cluster-management-agent --from-file=.dockerconfigjson=~/auth.json --type=kubernetes.io/dockerconfigjson
```

Now patch the following service accounts.

```
oc patch serviceaccount klusterlet -p '{"imagePullSecrets": [{"name": "rhacm"}]}' -n open-cluster-management-agent

oc patch serviceaccount klusterlet-work-sa -p '{"imagePullSecrets": [{"name": "rhacm"}]}' -n open-cluster-management-agent
```

It may be required to delete the pods that are in an "ImagePullBackOff" state.
```
for i in `oc get pods -n open-cluster-management-agent | grep ImagePullBackOff | awk '{print $1}'`; do oc delete pod $i -n open-cluster-management-agent; done
```

For the add-ons to work correctly, the following must be added to the MicroShift cluster.

```
oc create secret generic rhacm -n open-cluster-management-agent-addon --from-file=.dockerconfigjson=/home/vagrant/auth.json --type=kubernetes.io/dockerconfigjson

oc patch serviceaccount klusterlet-registration-sa -p '{"imagePullSecrets": [{"name": "rhacm"}]}' -n open-cluster-management-agent-addon
```

The secret must be added to the service accounts used by the add-ons.

```
for i in `oc get sa -n open-cluster-management-agent-addon | grep klusterlet | awk '{print $1}'`; do oc patch serviceaccount $i -p '{"imagePullSecrets": [{"name": "rhacm"}]}' -n open-cluster-management-agent-addon; done
```

It may be required to delete the pods that are in an "ImagePullBackOff" state.
```
for i in `oc get pods -n open-cluster-management-agent-addon | grep ImagePullBackOff | awk '{print $1}'`; do oc delete pod $i -n open-cluster-management-agent-addon; done
```

The cluster now should have all add-ons enabled and be in a READY state within RHACM.