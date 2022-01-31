---
title: "Getting Started"
weight: 20
main_menu: true
content_type: concept
description: "MicroShift system requirements and deployment"
---
## System Requirements

To run MicroShift, you need a machine with at least:

- a supported 64-bit<sup>2</sup> CPU architecture (amd64, arm64, or riscv64)
- a supported OS (see below)
- 2 CPU cores
- 2GB of RAM
- 1GB of free storage space for MicroShift

<sup>2) 32-bit is _technically_ possible, if you're up for the challenge.</sup>

## Deploying MicroShift on Edge Devices

For production deployments, we recommend (and only test) deploying MicroShift on RHEL 8, CentOS Stream 8, or Fedora 34+ using one of two methods:

- running containerized with `Podman`
- installing via .rpm (e.g. for embedding MicroShift into an `rpm-ostree` image)

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

{{< tabs >}}
{{% tab name="Podman" %}}
To have `systemd` start and manage MicroShift on Podman, run:

```Bash
sudo dnf install -y podman
sudo curl -o /etc/systemd/system/microshift.service \
     https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift-containerized.service
sudo systemctl enable microshift --now
```

{{% /tab %}}
{{% tab name=".rpm" %}}
To have `systemd` start and manage MicroShift on an rpm-based host, run:

```Bash
sudo dnf copr enable -y @redhat-et/microshift
sudo dnf install -y microshift firewalld
sudo systemctl enable microshift --now
```

{{% /tab %}}
{{< /tabs >}}

### Install Clients

To access the cluster, install the OpenShift client or kubectl. Ensure that the proper architecture is used.

{{< tabs >}}
{{% tab name="amd64" %}}
```Bash
curl -O https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz
sudo tar -xf openshift-client-linux.tar.gz -C /usr/local/bin oc kubectl
```
{{% /tab %}}
{{% tab name="aarch" %}}
```Bash
curl -O https://mirror.openshift.com/pub/openshift-v4/aarch64/clients/ocp/stable/openshift-install-linux.tar.gz
sudo tar -xf openshift-client-linux.tar.gz -C /usr/local/bin oc kubectl
```


{{% /tab %}}
{{< /tabs >}}



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
and useful tools like the `oc` client, so it can run on most modern Linux distros, on MacOS, and on Windows with `podman` or `docker` installed.
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
{{% tab name="MacOS" %}}
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
