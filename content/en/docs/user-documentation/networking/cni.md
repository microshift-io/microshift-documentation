---
title: "CNI Plugin"
weight: 100
description: The CNI Plugin used in MicroShift.
card:
  name: networking
  weight: 100
---

MicroShift uses the flannel CNI network plugin as lightweight (but less
featureful) alternative to OpenShiftSDN or OVNKubernetes.

This provides worker node to worker node pod connectivity via vxlan tunnels.

For single node operation the crio-bridge plugin could be used for additional
resource saving.

Both flannel and crio-bridge have no support for _NetworkPolicy_.
