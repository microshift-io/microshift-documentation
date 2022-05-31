---
title: "Differences between MicroShift and OKD"
weight: 100
main_menu: true
content_type: concept
description: "Addressing some innate differences between OKD and MicroShift."
---
# Differences Between OKD and MicroShift

The design goals behind MicroShift diverge from those of OKD as a necessity of the very different operating environments each project targets.  Namely, OKD achieves the goal of providing a full-stack, self-managed container appliction platform, targeting developer and operations-centric use cases on cloud infrastructure. MicroShift aims to provide an minimal OpenShift experience on small form factor, often headless devices with as conservative a resource overhead as possible. To further the project's goals, the MicroShift team has reduced OKD's feature set to remove functionality not well suited for edge use cases.

## Deployment

MicroShift's deployment model differs significantly from OKD's.  [Openshift-install](https://github.com/openshift/okd#getting-started) fully automates OKD deployment on cloud or baremetal infrastructure and manages system dependencies and configuration.  It goes a long way to provide a streamlined installation model for users.  MicroShift, being a single binary, can be installed atomically and managed like any other app. The user is expected to have some basic knowledge of package installation tools (dnf, yum, rpm).

The MicroShift [documentation](https://microshift.io/docs/getting-started/#install-cri-o) provides a step-by-step recipe for preparing a system and installing the app on supported operating systems.

## Control-Plane Services

The most notable difference between an OKD and MicroShift runtime are the lack of [operators](https://docs.openshift.com/container-platform/4.8/operators/operator-reference.html#machine-config-operator_platform-operators-ref). Running an operator for each control-plane component becomes quite costly at the edge.  Operators are built on the [operator-framework](https://operatorframework.io/), which provides a wonderful toolset and boilerplate for orchestrating application lifecycle management.  In order to reduce the platform's resource footprint, MicroShift compiles the control-plane into a single binary. This architecture means that the control-plane applications are not managed through the Kubernetes API, making the role of their operators moot.  The result of this design is a measurable reduction of redundant code (operator boilerplate) and a lower runtime overhead.  For most cases, we do not expect this to impact application portability.

#### Embedded Services

##### Control-Plane

- etcd
- kube-scheduler
- kube-apiserver
- openshift-api-server
- kube-controller-manager
- openshift-controller-manager
- openshift-oath
- [multicast dns](https://github.com/openshift/microshift/pull/429) (for multi-node enablement)

##### Node

- kubelet
- kube-proxy

#### Deployed Services

Post boot, MicroShift deploys the following services:

- openshift-service-ca
- openshift-ingress
- kubevirt-hostpath-provisioner
