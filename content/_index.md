---
title: "MicroShift"
---

MicroShift is a research project that is exploring how OpenShift<sup>1</sup> and Kubernetes can be optimized for small form factor and edge computing.

Edge devices deployed out in the field pose very different operational, environmental, and business challenges from those of cloud computing. These motivate different engineering trade-offs for Kubernetes at the far edge than for cloud or near-edge scenarios. MicroShift's design goals cater to this:

- make frugal use of system resources (CPU, memory, network, storage, etc.),
- tolerate severe networking constraints,
- update (resp. rollback) securely, safely, speedily, and seamlessly (without disrupting workloads), and
- build on and integrate cleanly with edge-optimized OSes like Fedora IoT and RHEL for Edge, while
- providing a consistent development and management experience with standard OpenShift.

We believe these properties should also make MicroShift a great tool for other use cases such as Kubernetes applications development on resource-constrained systems, scale testing, and provisioning of lightweight Kubernetes control planes.

Watch this [end-to-end MicroShift provisioning demo video](https://youtu.be/QOiB8NExtA4) to get a first impression of MicroShift deployed onto a [RHEL for edge computing](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux/edge-computing) device and managed through [Open Cluster Management](https://github.com/open-cluster-management).

{{< warning >}}
MicroShift is still early days and moving fast. Features are missing. Things break. But you can still help shape it, too.
{{< /warning >}}

<sup>1) more precisely [OKD](https://www.okd.io/), the Kubernetes distribution by the OpenShift community</sup>

## Getting Started
### System Requirements
To run MicroShift, you need a machine with at least:

- a supported 64-bit<sup>2</sup> CPU architcture (amd64, arm64, or riscv64)
- a supported OS (see below)
- 2 CPU cores
- 2GB of RAM
- 200MB of free storage space for MicroShift

<sup>2) 32-bit is _technically_ possible, if you're up for the challenge.</sup>

### Deploying MicroShift to Edge Devices

For production deployments, we recommend (and only test) deploying MicroShift on RHEL 8, CentOS Stream 8, or Fedora 35+ using one of two methods:

- running containerized on Podman
- installing via .rpm (e.g. for embedding MicroShift into an `rpm-ostree` image)

Both methods feature a minimmal resource footprint, a strong security posture, the ability to restart/update without disrupting workloads, and optionally auto-updates.

{{< tabs >}}
{{% tab name="Podman" %}}
MicroShift requires CRI-O to be installed on the host:

```Bash
```

To have `systemd` start and manage MicroShift on Podman, run:

```Bash
sudo curl -o /etc/systemd/system/microshift.service https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift-containerized.service
sudo systemctl enable microshift --now
```
{{% /tab %}}
{{% tab name=".rpm" %}}
MicroShift requires CRI-O to be installed on the host:

```Bash
```

To have `systemd` start and manage MicroShift on the host, run:
```Bash
sudo dnf copr enable -y @redhat-et/microshift
sudo dnf install -y microshift firewalld
sudo systemctl enable crio --now
sudo systemctl enable microshift --now
```
{{% /tab %}}
{{< /tabs >}}

### Using MicroShift for Application Development

For trying out MicroShift or using it as development tool, we provide a flavor of MicroShift that bundles host dependencies like CRI-O and useful tools like the `oc` client, so it can run on most modern Linux distros, on OSX, and on Windows with `podman` or `docker` installed.

{{< tabs >}}
{{% tab name="Linux" %}}
[Install `podman`]() if necessary, then run MicroShift using:

```Bash
command -v setsebool >/dev/null 2>&1 || sudo setsebool -P container_manage_cgroup true
sudo podman run -d --rm --name microshift --privileged -p 6443:6443 quay.io/microshift/microshift-aio:latest
```

You can then access your cluster either via the bundled `oc` (resp. `kubectl`) command

```Bash
sudo podman exec -ti microshift -- oc get all -A
```

or via an `oc` (resp. `kubectl`) client [installed]() on the host:

```Bash
sudo podman cp microshift:/var/lib/microshift/resources/kubeadmin/kubeconfig ./kubeconfig
oc get all -A --kubeconfig ./kubeconfig
```
{{% /tab %}}
{{% tab name="OSX" %}}
[Install `podman`]() if necessary, then start a Podman machine and ssh into it:

```Bash
podman machine init
podman machine start
podman machine ssh
```

From within the ssh session, run:

```Bash
sudo setsebool -P container_manage_cgroup true
sudo podman run -d --rm --name microshift --privileged --hostname microshift -p 6443:6443 quay.io/microshift/microshift-aio:latest
```

After the cluster is up (~3-4min), exit the ssh session and return to the host.

You can then access your cluster either via the bundled `oc` (resp. `kubectl`) command

```Bash
podman machine ssh sudo podman exec -ti microshift -- oc get all -A
```

or via an `oc` (resp. `kubectl`) client [installed]() on the host:

```Bash
podman machine ssh sudo podman exec microshift cat /var/lib/microshift/resources/kubeadmin/kubeconfig > ./kubeconfig
oc get all -A --kubeconfig ./kubeconfig
```
{{% /tab %}}
{{% tab name="Windows" %}}
[Install `docker`]() if necessary, then run MicroShift using:

```Bash
docker.exe run -d --rm --name microshift --privileged -p 6443:6443 quay.io/microshift/microshift-aio:latest
```

You can then access your cluster either via the bundled `oc` (resp. `kubectl`) command

```Bash
docker.exe exec -ti microshift -- oc get all -A
```

or via an `oc` (resp. `kubectl`) client [installed]() on the host:

```Bash
docker.exe cp microshift:/var/lib/microshift/resources/kubeadmin/kubeconfig .\kubeconfig
oc.exe get all -A --kubeconfig .\kubeconfig
```
{{% /tab %}}
{{< /tabs >}}

## User Documentation
[MicroShift user documentation](https://microshift.io/docs/user-documentation/)

## Developer Documentation
[Building and running MicroShift](https://microshift.io/docs/developer-documentation/) for local development

## Community
MicroShift community is growing, we hope you can [get involved!](https://microshift.io/docs/community/community/)