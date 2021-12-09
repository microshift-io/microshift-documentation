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

## Deploying MicroShift to Edge Devices

For production deployments, we recommend (and only test) deploying MicroShift on RHEL 8, CentOS Stream 8, or Fedora 34+ using one of two methods:

- running containerized on Podman
- installing via .rpm (e.g. for embedding MicroShift into an `rpm-ostree` image)

Both methods feature a minimal resource footprint, a strong security posture, the ability to restart/update without disrupting workloads, and optionally auto-updates.

{{< tabs >}}
{{% tab name="Podman" %}}
MicroShift requires CRI-O to be installed on the host:

```Bash
command -v subscription-manager &> /dev/null \
    && subscription-manager repos --enable rhocp-4.8-for-rhel-8-x86_64-rpms \
    || sudo dnf module enable -y cri-o:1.21
sudo dnf install -y crio cri-tools podman
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
MicroShift requires CRI-O to be installed on the host:

```Bash
command -v subscription-manager >/dev/null 2>&1 \
    && subscription-manager repos --enable rhocp-4.8-for-rhel-8-x86_64-rpms \
    || sudo dnf module enable -y cri-o:1.21
sudo dnf install -y crio cri-tools
sudo systemctl enable crio --now
```

<br/>

To have `systemd` start and manage MicroShift on the host, run:

```Bash
sudo dnf copr enable -y @redhat-et/microshift
sudo dnf install -y microshift firewalld
sudo systemctl enable microshift --now
```

{{% /tab %}}
{{< /tabs >}}
<br/>

## Accessing the cluster

Kubectl and the OpenShift client can be used to access objects within the cluster.

```Bash
curl -o oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz
tar -xzvf oc.tar.gz
sudo install -t /usr/local/bin {kubectl,oc}
```

Depending on the user that will be administrating the system it may be required to copy the kubeconfig to a location that can be accessed by the user.

```Bash
mkdir ~/.kube
sudo cp /var/lib/microshift/resources/kubeadmin/kubeconfig ~/.kube/config
sudo chown `whoami`: ~/.kube/config
```

It is now possible to run kubectl or oc commands against the MicroShift environment.

### Using MicroShift for Application Development

For trying out MicroShift or using it as development tool, we provide a flavor of MicroShift that bundles host dependencies like CRI-O and useful tools like the `oc` client, so it can run on most modern Linux distros, on OSX, and on Windows with `podman` or `docker` installed.

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
{{% tab name="OSX" %}}
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
oc get all -A --kubeconfig .\kubeconfig
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