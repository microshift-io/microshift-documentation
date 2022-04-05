---
title: Dynamic Provisioning of PVs
draft: false
weight: 9
tags:
  - pvc
  - hostpath provisioner
description: MicroShift storage solution can provision persistent volumes dynamically based on claims.
---

MicroShift deploys the [hostpath provisioner](https://github.com/kubevirt/hostpath-provisioner) as solution to provide persistent storage to pods. The hostpath provisioner pod mounts the `/var/hpvolumes` directory in order to provision volumes. It also has the ability to dynamically provision PVs when a PVC is created, and wait until a pod uses that specific PVC. 

Let's see how to create a PVC so the hostpath provisioner creates the persistent volume for us. 

### Create a Persistent Volume Claim

MicroShift's hostpath provisioner creates a `StorageClass` named `kubevirt-hostpath-provisioner` by default.

The PVC manifest must reference this `StorageClass` using the `storageClassName` spec parameter and there should be an annotation pointing at the node where the PV is going to be created. *This annotation is crucial if we want dynamic provisioning of PVs*: 


```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
  annotations:
    kubevirt.io/provisionOnNode: ricky-fedora.oglok.net
spec:
  storageClassName: kubevirt-hostpath-provisioner
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
```

This manifest will create the following Persistent Volume Claim and a Persistent Volume located at `/var/hpvolumes/`. 

```sh
$ oc get pvc
NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS                    AGE
task-pv-claim   Bound    pvc-58a28c40-7726-4830-ba70-32d18188a8b4   39Gi       RWO            kubevirt-hostpath-provisioner   8m43s
$ oc get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                   STORAGECLASS                    REASON   AGE
pvc-58a28c40-7726-4830-ba70-32d18188a8b4   39Gi       RWO            Delete           Bound    default/task-pv-claim   kubevirt-hostpath-provisioner            8m43s

$ ll /var/hpvolumes/
total 0
drwxrwxrwx. 1 root root 8 Apr  5 10:26 pvc-58a28c40-7726-4830-ba70-32d18188a8b4
```

For sake of clarity, we will instantiate a sample NGINX pod that mounts that volume:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: task-pv-pod
spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: task-pv-claim
  containers:
    - name: task-pv-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: task-pv-storage
```

Any HTML file located at `/var/hpvolumes/pvc-58a28c40-7726-4830-ba70-32d18188a8b4` can be exposed by the NGINX running in the pod using a regular service.

