---
title: RPM install
tags:
  - rpm
  - non-containerized
draft: false
weight: 20
description: Deploy MicroShift from RPM and run as a systemd service.
content_type: concept
card:
  name: deployment-guide
  weight: 20
---

<!-- overview -->

Deploy MicroShift from RPM and run as a systemd service.

<!-- body -->

A ready to go MicroShift environment can be installed from RPM, along with the systemd unit file to run the MicroShift binary as a service.

### When to Use

MicroShift install with RPM is the recommended deployment method for production workloads with MicroShift.

### Prerequisites

- Refer to the [System Requirements]({{< ref "/docs/getting-started/system-requirements.md" >}})
- CRI-O repositories or CRI-O installed on system. [CRI-O install info here]({{< ref "/docs/developer-documentation/local-development.md#installing-cri-o" >}})

### Deployment Architecture

- MicroShift systemd service
- CRI-O systemd service
- storage at `/var/lib/microshift` & `/var/lib/kubelet`

### Install and Run MicroShift RPM

```bash
dnf copr enable -y @redhat-et/microshift-nightly
dnf install -y microshift firewalld
systemctl enable crio --now
systemctl enable microshift --now
```

Verify that MicroShift is running (startup and image pulls take a few minutes to complete).

```sh
kubectl get pods -A
```

You can stop MicroShift service with systemd

```bash
systemctl stop microshift
```

{{< note >}}
MicroShift data at `/var/lib/microshift` and `/var/lib/kubelet`, will not be deleted upon stopping services.

Upon a restart, the cluster state will persist as long as the storage is intact.
{{< /note >}}

Now that MicroShift is running, refer to the [user documentation]({{< ref "/docs/user-documentation/_index.md" >}})

### RHEL 4 Edge

When running with an rpm-ostree OS such as RHEL 4 Edge, MicroShift will be baked into the Operating System.
All updates, therefor, are handled via OS update. `rpm-ostree` based systems are immutable, this is by design.
[More on RHEL 4 Edge and rpm-ostree](https://www.redhat.com/en/blog/dive-red-hat-enterprise-linux-edge-labs).
