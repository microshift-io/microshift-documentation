---
title: MicroShift for edge
weight: 1
card:
  name: getting-started
  weight: 1
tags:
  - project overview
description: MicroShift is optimized for edge computing.
---

Edge devices deployed out in the field pose very different operational, environmental, and business challenges from those of cloud computing. These motivate different engineering trade-offs for Kubernetes at the far edge than for cloud or near-edge scenarios.

MicroShift's design goals cater to edge computing:

- make frugal use of system resources (CPU, memory, network, storage, etc.),
- tolerate severe networking constraints,
- update (resp. roll back) securely, safely, speedily, and seamlessly (without disrupting workloads), and
- build on and integrate cleanly with edge-optimized OSes like Fedora IoT and RHEL for Edge, while
- providing a consistent development and management experience with standard OpenShift.

We believe these properties should also make MicroShift a great tool for other use cases such as Kubernetes applications development on resource-constrained systems, scale testing, and provisioning of lightweight Kubernetes control planes.

Watch this [end-to-end MicroShift provisioning demo video](https://youtu.be/QOiB8NExtA4) to get a first impression of MicroShift deployed onto a [RHEL for edge computing](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux/edge-computing) device and managed through [Open Cluster Management](https://github.com/open-cluster-management).

{{< warning >}}
MicroShift is still early days and moving fast. Features are missing. Things break. But you can still help shape it, too.
{{< /warning >}}
