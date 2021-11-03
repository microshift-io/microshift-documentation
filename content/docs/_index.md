---
title: 'Overview'
date: 2018-11-28T15:14:39+10:00
weight: 1
---

MicroShift is a research project that is exploring how OpenShift<sup>1</sup> Kubernetes can be optimized for small form factor and edge computing.

Edge devices deployed out in the field pose very different operational, environmental, and business challenges from those of cloud computing. These motivate different engineering trade-offs for Kubernetes at the far edge than for cloud or near-edge scenarios. MicroShift's design goals cater to this:

- make frugal use of system resources (CPU, memory, network, storage, etc.),
- tolerate severe networking constraints,
- update (resp. roll back) securely, safely, speedily, and seamlessly (without disrupting workloads), and
- build on and integrate cleanly with edge-optimized OSes like Fedora IoT and RHEL for Edge, while
- providing a consistent development and management experience with standard OpenShift.

We believe these properties should also make MicroShift a great tool for other use cases such as Kubernetes applications development on resource-constrained systems, scale testing, and provisioning of lightweight Kubernetes control planes.

Watch this [end-to-end MicroShift provisioning demo video](https://youtu.be/QOiB8NExtA4) to get a first impression of MicroShift deployed onto a [RHEL for edge computing](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux/edge-computing) device and managed through [Open Cluster Management](https://github.com/open-cluster-management).

{{< warning >}}
MicroShift is still early days and moving fast. Features are missing. Things break. But you can still help shape it, too.{{\*\*
{{< /warning >}}

<sup>1) more precisely [OKD](https://www.okd.io/), the Kubernetes distribution by the OpenShift community</sup>

## Minimum specs

In order to run MicroShift, you will need at least:

- 2 CPU cores
- 2GB of RAM
- ~124MB of free storage space for the MicroShift binary
- 64-bit CPU (although 32-bit is _technically_ possible, if you're up for the challenge)

For barebones development the minimum requirement is 3GB of RAM, though this can increase
if you are using resource-intensive devtools.

### OS Requirements

The all-in-one containerized MicroShift can run on Windows, MacOS, and Linux.

Currently, the MicroShift binary is known to be supported on the following Operating Systems:

- Fedora 33/34
- CentOS 8 Stream
- RHEL 8
- CentOS 7
- Ubuntu 20.04

It may be possible to run MicroShift on other systems, however they haven't been tested so you may run into issues.

### Community

Join us on [Slack](https://microshift.slack.com)!

Community meetings are held weekly, Wednesdays at 10:30AM - 11:00AM EST. Be sure to join the community [calendar](https://calendar.google.com/calendar/embed?src=nj6l882mfe4d2g9nr1h7avgrcs%40group.calendar.google.com&ctz=America%2FChicago)! Click "Google Calendar" in the lower right hand corner to subscribe.
