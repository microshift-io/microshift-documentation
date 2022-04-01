---
title: "Getting Started"
weight: 20
main_menu: true
content_type: concept
description: "MicroShift system requirements and deployment"
---
## System Requirements

To run MicroShift, you need a machine with at least:

- a supported 64-bit<sup>2</sup> CPU architecture (amd64/x86_64, arm64, or riscv64)
- a supported OS (see below)
- 2 CPU cores
- 2GB of RAM
- 1GB of free storage space for MicroShift

<sup>2) 32-bit is _technically_ possible, if you're up for the challenge.</sup>

## Deploying MicroShift on Edge Devices

For production deployments, we recommend (and only test) deploying MicroShift on RHEL 8, CentOS Stream 8, or Fedora 34+ using one of two methods:

- running containerized with `Podman`
- installing via .rpm (e.g. for embedding MicroShift into an [`rpm-ostree`]({{< ref "/docs/getting-started/_index.md#microshift-on-ostree-based-systems" >}}) image)

Both methods feature a minimal resource footprint, a strong security posture, the ability to restart/update without disrupting workloads, and optionally auto-updates.

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
{{% tab name="CentOS 8 Stream" %}}

```Bash
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8_Stream/devel:kubic:libcontainers:stable.repo
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:1.21.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:1.21/CentOS_8_Stream/devel:kubic:libcontainers:stable:cri-o:1.21.repo
sudo dnf install -y cri-o cri-tools
sudo systemctl enable crio --now
```

{{% /tab %}}
{{< /tabs >}}

<br/>

### Deploying MicroShift
The following steps will deploy MicroShift and enable `firewalld`. It is always best practice to have firewalls enabled and only to allow the minimum set of ports necessary for MicroShift to operate. `Iptables` can be used in place of `firewalld` if desired.

{{< tabs >}}
{{% tab name="Podman" %}}
To have `systemd` start and manage MicroShift on Podman, run:

```Bash
sudo dnf install -y podman
sudo curl -o /etc/systemd/system/microshift.service \
     https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift-containerized.service
sudo firewall-cmd --zone=trusted --add-source=10.42.0.0/16 --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=5353/udp --permanent
sudo firewall-cmd --reload
sudo systemctl enable microshift --now
```

{{% /tab %}}
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
{{% tab name="Podman" %}}

```Bash
mkdir ~/.kube
sudo podman cp microshift:/var/lib/microshift/resources/kubeadmin/kubeconfig ~/.kube/config
sudo chown `whoami`: ~/.kube/config
```

{{% /tab %}}
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

## Using MicroShift for Application Development

For trying out MicroShift or using it as development tool, we provide a MicroShift image that bundles host dependencies like CRI-O
and useful tools like the `oc` client, so it can run on most modern Linux distros, on macOS, and on Windows with `podman` or `docker` installed.
This bundled image is referred to as `aio` or `all-in-one` since it provides everything necessary to run MicroShift.
The all-in-one image is meant for ephemeral test environments only. There is no way to update the image without disruption of workloads and loss of data.
For production workloads, it is recommended to run with [MicroShift Containerized]({{< ref "/docs/getting-started/_index.md#launch-microshift-with-podman-and-systemd" >}}).

{{< tabs >}}
{{% tab name="Linux" %}}
[Install `podman`](https://podman.io/getting-started/installation#linux-distributions) if necessary, then run MicroShift using:

```Bash
command -v setsebool >/dev/null 2>&1 || sudo setsebool -P container_manage_cgroup true
sudo podman run -d --rm --name microshift --privileged -v microshift-data:/var/lib -p 6443:6443 quay.io/microshift/microshift-aio:latest
```
<br/>

You can then access your cluster either via the bundled `oc` (resp. `kubectl`) command

```Bash
sudo podman exec -ti microshift oc get all -A
```
<br/>

or via an `oc` (resp. `kubectl`) client installed on the host:

```Bash
sudo podman cp microshift:/var/lib/microshift/resources/kubeadmin/kubeconfig ./kubeconfig
oc get all -A --kubeconfig ./kubeconfig
```
{{% /tab %}}
{{% tab name="macOS" %}}
[Install `docker`](https://docs.docker.com/desktop/mac/install/) if necessary, then run MicroShift using:

```Bash
docker run -d --rm --name microshift --privileged -v microshift-data:/var/lib -p 6443:6443 quay.io/microshift/microshift-aio:latest
```
<br/>

You can then access your cluster either via the bundled `oc` (resp. `kubectl`) command

```Bash
docker exec -ti microshift oc get all -A
```
<br/>

or via an `oc` (resp. `kubectl`) client [installed](https://access.redhat.com/downloads/content/290/) on the host:

```Bash
docker cp microshift:/var/lib/microshift/resources/kubeadmin/kubeconfig ./kubeconfig
oc get all -A --kubeconfig ./kubeconfig
```
{{% /tab %}}
{{% tab name="Windows" %}}
[Install `docker`](https://docs.docker.com/desktop/windows/install/) if necessary, then run MicroShift using:

```Bash
docker.exe run -d --rm --name microshift --privileged -v microshift-data:/var/lib -p 6443:6443 quay.io/microshift/microshift-aio:latest
```
<br/>

You can then access your cluster either via the bundled `oc` (resp. `kubectl`) command

```Bash
docker.exe exec -ti microshift oc get all -A
```
<br/>

or via an `oc` (resp. `kubectl`) client [installed](https://access.redhat.com/downloads/content/290/) on the host:

```Bash
docker.exe cp microshift:/var/lib/microshift/resources/kubeadmin/kubeconfig .\kubeconfig
oc.exe get all -A --kubeconfig .\kubeconfig
```
{{% /tab %}}
{{< /tabs >}}

## MicroShift on OSTree based systems

As mentioned aboved, MicroShift has been designed to be deployed on edge computing devices. Looking at security standards, 
an edge optimized operating system will most likely be inmutable and based in transactions for upgrades and rollbacks. OSTree provides these capabilities. 

Fedora IoT and RHEL for Edge are both OSTree based systems and MicroShift can be shipped as part of the base `rpm-ostree`. 
The recommended way to embed MicroShift in these operating systems is to build your own `rpm-ostree` with tools like [Image Builder](https://fedoramagazine.org/introduction-to-image-builder/). This project will allow you to create your own customized version of Fedora IoT or RHEL for Edge in order to include MicroShift and all the required dependencies like CRI-O.

However, developers might need to manually install RPMs on the system for faster iterations. It is important to highlight that the base layer of an `rpm-ostree` is an atomic entity, so when installing a local package, any dependency that is part of the ostree with an older version will not be updated. This is the reason why it is mandatory to perform an upgrade before manually installing MicroShift.


Let's see an example of a Fedora IoT 35 system:

```
curl -L -o /etc/yum.repos.d/fedora-modular.repo https://src.fedoraproject.org/rpms/fedora-repos/raw/rawhide/f/fedora-modular.repo
curl -L -o /etc/yum.repos.d/fedora-updates-modular.repo https://src.fedoraproject.org/rpms/fedora-repos/raw/rawhide/f/fedora-updates-modular.repo
curl -L -o /etc/yum.repos.d/group_redhat-et-microshift-fedora-35.repo https://copr.fedorainfracloud.org/coprs/g/redhat-et/microshift/repo/fedora-35/group_redhat-et-microshift-fedora-35.repo
rpm-ostree ex module enable cri-o:1.21

rpm-ostree upgrade
rpm-ostree install cri-o cri-tools microshift

systemctl reboot
```

Now MicroShift and its dependencies will be part of the `rpm-ostree` and ready to function.
