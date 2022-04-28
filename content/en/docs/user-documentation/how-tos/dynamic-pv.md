---
title: Dynamic Provisioning of PVs
draft: false
weight: 9
tags:
  - pvc
  - pv
  - hostpath provisioner
  - storage
  - volume
  - dynamic
description: MicroShift Default Storage Solution
---

MicroShift deploys the [kubevirt-hostpath provisioner](https://github.com/kubevirt/hostpath-provisioner) as the default storage solution. The provisioner generates volumes under the `/var/hpvolumes` host directory. See the included [kubevirt-hostpath StorageClass](https://github.com/redhat-et/microshift/blob/main/assets/components/hostpath-provisioner/storageclass.yaml) for configuration, and [Kubernetes StorageClass documentation](https://kubernetes.io/docs/concepts/storage/storage-classes/#the-storageclass-resource) for the API reference, guides on StorageClass configuration and how-to's on utilizing dynamic provisioning.
