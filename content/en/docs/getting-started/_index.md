---
title: "Getting Started"
weight: 20
main_menu: true
content_type: concept
description: "MicroShift system requirements and deployment"
---
## Getting Started
### System Requirements
To run MicroShift, you need a machine with at least:

- a supported 64-bit<sup>2</sup> CPU architecture (amd64, arm64, or riscv64)
- a supported OS (see below)
- 2 CPU cores
- 2GB of RAM
- 1GB of free storage space for MicroShift

<sup>2) 32-bit is _technically_ possible, if you're up for the challenge.</sup>

### Deploying MicroShift to Edge Devices

For production deployments, we recommend (and only test) deploying MicroShift on RHEL 8, CentOS Stream 8, or Fedora 35+ using one of two methods:

- running containerized on Podman
- installing via .rpm (e.g. for embedding MicroShift into an `rpm-ostree` image)

Both methods feature a minimal resource footprint, a strong security posture, the ability to restart/update without disrupting workloads, and optionally auto-updates.

NOTE: For RHEL ensure that the repository "rhocp-4.7-for-rhel-8-x86_64-rpms" has been enabled for the system.

{{< tabs >}}
{{% tab name="Podman" %}}
MicroShift requires CRI-O to be installed on the host:

```Bash
sudo dnf module -y enable cri-o:1.21
sudo dnf install crio podman
sudo systemctl enable crio --now
```
<br/>

To have `systemd` start and manage MicroShift on Podman, run:

```Bash
sudo curl -o /etc/systemd/system/microshift.service \
     https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift-containerized.service
sudo systemctl enable microshift --now
```
{{% /tab %}}
{{% tab name=".rpm" %}}

To have `systemd` start and manage MicroShift on the host, run:
```Bash
sudo dnf module -y enable cri-o:1.21
sudo dnf copr enable -y @redhat-et/microshift
sudo dnf install -y microshift firewalld
sudo systemctl enable crio --now
sudo systemctl enable microshift --now
```
{{% /tab %}}
{{< /tabs >}}

### Accessing the cluster
Kubectl and the OpenShift client can be used to access objects within the cluster.
```Bash
curl -o oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz
tar -xzvf oc.tar.gz
sudo mv kubectl /usr/local/bin/
sudo mv oc /usr/local/bin/
```

Depending on the user that will be administrating the system it may be required to copy the kubeconfig to a location that can be accessed by the user.
```Bash
mkdir ~/.kube
sudo cp /var/lib/microshift/resources/kubeadmin/kubeconfig ~/.kube/config
sudo chown `whoami`: ~/.kube/config
```

It is now possible to run kubectl or oc commands against the MicroShift environment.