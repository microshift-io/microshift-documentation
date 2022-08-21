---
title: "Building and Installing the MicroShift RPMs"
tags:
  - develop
  - build
  - rpm
draft: false
weight: 20
card:
  name: developer-documentation
  weight: 20
description: Building and installing the MicroShift RPMs for local development
---

## Building the RPMs

MicroShift binary with systemd unit file and the required SELinux submodule can be built as an RPM using `make` on an RPM-based distribution.

Install the [MicroShift build dependencies]({{< ref "/docs/developer-documentation/local-development.md#build-dependencies" >}}) and the RPM specific build-time packages.

```bash
sudo dnf install -y git golang rpm-build selinux-policy-devel container-selinux
```

Clone the repository and cd into it:
{{< warning >}}
The available community documentation is not currently compatible with the latest MicroShift source code.
To build the latest MicroShift RPMs, follow the instructions in the [openshift/microshift GitHub repository](https://github.com/openshift/microshift).

Otherwise, use the `4.8.0-microshift-2022-04-20-141053` branch when working with the source repository and these instructions.
{{< /warning >}}

```sh
git clone -b 4.8.0-microshift-2022-04-20-141053 https://github.com/openshift/microshift.git
cd microshift
```

Build the SELinux and MicroShift RPMs with:

```bash
make rpm
```

RPMs will be placed in `./packaging/rpm/_rpmbuild/RPMS/`. There are two RPMs that will be required to install:

```
packaging/rpm/_rpmbuild/RPMS/noarch/microshift-selinux-*
packaging/rpm/_rpmbuild/RPMS/x86_64/microshift-*
```

## Installing the RPMs

Enable the CRI-O repository:

{{< tabs >}}
{{% tab name="RHEL" %}}

```Bash
command -v subscription-manager &> /dev/null \
    && subscription-manager repos --enable rhocp-4.8-for-rhel-8-x86_64-rpms
```

{{% /tab %}}
{{% tab name="Fedora" %}}

```Bash
sudo dnf module enable -y cri-o:1.21
```
{{% /tab %}}
{{% tab name="CentOS Stream" %}}

```Bash
sudo dnf module enable -y cri-o:1.21
```

{{% /tab %}}
{{< /tabs >}}

<br/>

Install the MicroShift and the SELinux policies:

```bash
sudo dnf localinstall -y packaging/rpm/_rpmbuild/RPMS/noarch/microshift-selinux-*
sudo dnf localinstall -y packaging/rpm/_rpmbuild/RPMS/x86_64/microshift-*
```

## Running the RPMs

Start CRI-O and MicroShift services:

```Bash
sudo systemctl enable crio --now
sudo systemctl enable microshift --now
```

To install OpenShift and Kubernetes clients, follow [Getting Started: Install Clients]({{< ref "/docs/getting-started/_index.md#install-clients" >}}).

To configure the kubeconfig, follow [Getting Started: Copy Kubeconfig]({{< ref "/docs/getting-started/_index.md#copy-kubeconfig" >}}).

It is now possible to run `oc` or `kubectl` commands against the MicroShift environment.

Verify that MicroShift is running:

```sh
oc get pods -A
```

You can stop MicroShift service with systemd:

```bash
sudo systemctl stop microshift
```

{{< note >}}
- cluster data at `/var/lib/microshift` and `/var/lib/kubelet`, will not be deleted upon stopping services.
  Upon a restart, the cluster state will persist as long as the storage is intact.
{{< /note >}}

Check MicroShift with

```bash
sudo podman ps
sudo critcl ps
```

For more on running MicroShift, refer to the [user documentation]({{< ref "/docs/user-documentation/_index.md" >}})
