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
The remaining steps will be run on the MicroShift cluster

To correctly fetch images, a secret must be added and service accounts must be patched to allow access. To begin, create secret to access registry.redhat.io.

```
podman login registry.redhat.io --authfile=~/auth.json
```

Now, we will precreate the namespace `open-cluster-management-addon`, the associated service accounts and patch them to use the rhacm secret

```
oc new-project open-cluster-management-agent
oc create secret generic rhacm --from-file=.dockerconfigjson=auth.json --type=kubernetes.io/dockerconfigjson
oc create sa klusterlet
oc patch sa klusterlet -p '{"imagePullSecrets": [{"name": "rhacm"}]}' -n open-cluster-management-agent
oc create sa klusterlet-registration-sa
oc patch sa klusterlet-registration-sa -p '{"imagePullSecrets": [{"name": "rhacm"}]}'
oc create sa klusterlet-work-sa
oc patch sa klusterlet-work-sa -p '{"imagePullSecrets": [{"name": "rhacm"}]}'
oc patch serviceaccount klusterlet -p '{"imagePullSecrets": [{"name": "rhacm"}]}' -n open-cluster-management-agent
oc patch serviceaccount klusterlet-work-sa -p '{"imagePullSecrets": [{"name": "rhacm"}]}' -n open-cluster-management-agent
```

For the add-ons, we do something similar in the `open-cluster-management-agent-addon` namespace

```
oc new-project open-cluster-management-agent-addon
oc create secret generic rhacm --from-file=.dockerconfigjson=auth.json --type=kubernetes.io/dockerconfigjson
oc create sa klusterlet-addon-operator
oc patch sa klusterlet-addon-operator -p '{"imagePullSecrets": [{"name": "rhacm"}]}'
```

Now, we actually create the relevant CRDS and the jobs that register our instance to ACM

```
oc project open-cluster-management-agent
echo $CRDS | base64 -d | oc apply -f -
echo $IMPORT | base64 -d | oc apply -f -
```

In the case of the add ons, precreating some of the service accounts would cause helm failures so we need to wait for them to actually get created before patching them. It generally takes 2-3 minutes, and we are then able to patch said service accounts and then delete all pods of the namespace for the pods to be created properly

```
oc project open-cluster-management-agent-addon
for sa in klusterlet-addon-appmgr klusterlet-addon-certpolicyctrl klusterlet-addon-iampolicyctrl-sa klusterlet-addon-policyctrl klusterlet-addon-search klusterlet-addon-workmgr ; do
  oc patch sa $sa -p '{"imagePullSecrets": [{"name": "rhacm"}]}'
done
oc delete pod --all -n open-cluster-management-agent-addon
```

The cluster now should have all add-ons enabled and be in a READY state within RHACM.
