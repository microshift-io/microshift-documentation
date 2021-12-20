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
dnf install -y rpm-build selinux-policy-devel container-selinux
```

Clone the repository and cd into it:

```sh
git clone https://github.com/redhat-et/microshift.git
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

Enable the CRI-O repo:

```Bash
command -v subscription-manager &> /dev/null \
    && subscription-manager repos --enable rhocp-4.8-for-rhel-8-x86_64-rpms \
    || sudo dnf module enable -y cri-o:1.21
```

Install the MicroShift and the SELinux policies:

```bash
sudo dnf localinstall -y packaging/rpm/_rpmbuild/RPMS/noarch/microshift-selinux-*
sudo dnf localinstall -y packaging/rpm/_rpmbuild/RPMS/x86_64/microshift-*
```

## Running the RPMs

Start CRI-O and MicroShift services:

```Bash
systemctl enable crio --now
systemctl enable microshift --now
```

Verify that MicroShift is running:

```sh
export KUBECONFIG=/var/lib/microshift/resources/kubeadmin/kubeconfig
sudo oc get pods -A
```

You can stop MicroShift service with systemd:

```bash
systemctl stop microshift
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
