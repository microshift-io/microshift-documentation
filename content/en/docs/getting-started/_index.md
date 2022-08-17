---
title: "Getting Started"
weight: 20
main_menu: true
content_type: concept
description: "MicroShift system requirements and deployment"
---
## System Requirements

To run MicroShift, you need a machine with at least:

- a supported 64-bit CPU architecture (amd64/x86_64, arm64, or riscv64)
- a supported OS (see below)
- 2 CPU cores
- 2GB of RAM
- 1GB of free storage space for MicroShift

## Deploying MicroShift on Edge Devices

{{< warning >}}
The available community documentation is not currently compatible with the latest MicroShift source code.
It is recommended to follow the instructions in the [openshift/microshift GitHub repository](https://github.com/openshift/microshift).
{{< /warning >}}

We recommend (and only test) deploying MicroShift on RHEL 8, CentOS Stream, or Fedora 34+ installing via RPM (e.g. for embedding MicroShift into an [`rpm-ostree`]({{< ref "/docs/getting-started/_index.md#microshift-on-ostree-based-systems" >}}) image).

This installation techique has a minimal resource footprint, a strong security posture, the ability to restart/update without disrupting workloads, and optionally auto-updates.

### Install CRI-O

MicroShift requires CRI-O to be installed and running on the host:

{{< tabs >}}
{{% tab name="RHEL" %}}

```Bash
command -v subscription-manager &> /dev/null \
    && subscription-manager repos --enable rhocp-4.8-for-rhel-8-x86_64-rpms
sudo dnf install -y cri-o cri-tools
sudo systemctl enable crio --now
```

{{% /tab %}}
{{% tab name="Fedora" %}}

```Bash
sudo dnf module enable -y cri-o:1.21
sudo dnf install -y cri-o cri-tools
sudo systemctl enable crio --now
```
{{% /tab %}}
{{% tab name="CentOS Stream" %}}

```Bash
sudo dnf module enable -y cri-o:1.21
sudo dnf install -y cri-o cri-tools
sudo systemctl enable crio --now
```

{{% /tab %}}
{{< /tabs >}}

<br/>

### Deploying MicroShift
The following steps will deploy MicroShift and enable `firewalld`. It is always best practice to have firewalls enabled and only to allow the minimum set of ports necessary for MicroShift to operate. `Iptables` can be used in place of `firewalld` if desired.

{{< tabs >}}
{{% tab name=".rpm" %}}
To have `systemd` start and manage MicroShift on an rpm-based host, run:

```Bash
sudo dnf copr enable -y @redhat-et/microshift
sudo dnf install -y microshift
sudo firewall-cmd --zone=trusted --add-source=10.42.0.0/16 --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=5353/udp --permanent
sudo firewall-cmd --reload
sudo systemctl enable microshift --now
```

{{% /tab %}}
{{< /tabs >}}

For more details on MicroShift ports and firewall settings, please see the
[firewall documentation](../user-documentation/networking/firewall.md).

### Install Clients

To access the cluster, install the OpenShift client or kubectl. 

```Bash
curl -O https://mirror.openshift.com/pub/openshift-v4/$(uname -m)/clients/ocp/stable/openshift-client-linux.tar.gz
sudo tar -xf openshift-client-linux.tar.gz -C /usr/local/bin oc kubectl
```


### Copy Kubeconfig

Copy the kubeconfig to the default location that can be accessed without administrator privilege.

{{< tabs >}}
{{% tab name=".rpm" %}}
```Bash
mkdir ~/.kube
sudo cat /var/lib/microshift/resources/kubeadmin/kubeconfig > ~/.kube/config
```

{{% /tab %}}
{{< /tabs >}}

It is now possible to run kubectl or oc commands against the MicroShift environment.
Verify that MicroShift is running:

```sh
oc get pods -A
```

## MicroShift on OSTree based systems

As mentioned aboved, MicroShift has been designed to be deployed on edge computing devices. Looking at security standards, 
an edge optimized operating system will most likely be inmutable and based in transactions for upgrades and rollbacks. OSTree provides these capabilities. 

Fedora IoT and RHEL for Edge are both OSTree based systems and MicroShift can be shipped as part of the base `rpm-ostree`. 
The recommended way to embed MicroShift in these operating systems is to build your own `rpm-ostree` with tools like [Image Builder](https://fedoramagazine.org/introduction-to-image-builder/). This project will allow you to create your own customized version of Fedora IoT or RHEL for Edge in order to include MicroShift and all the required dependencies like CRI-O.
