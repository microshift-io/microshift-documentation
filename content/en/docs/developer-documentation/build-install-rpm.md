---
title: "RPM build & install"
tags:
  - develop
  - build
  - rpm
draft: false
weight: 3
card:
  name: developer-documentation
  weight: 3
description: Building and installing MicroShift RPM
---

### Building MicroShift RPM

MicroShift binary with systemd unit file and the required SELinux submodule can be built as an RPM using `make` on an RPM-based distribution.

Install the [MicroShift build dependencies]({{< ref "/docs/developer-documentation/local-development.md#build-dependencies" >}}) and the RPM specific build-time packages.
Also, [install CRI-O]({{< ref "/docs/developer-documentation/local-development.md#installing-cri-o" >}}) (or, at least, add the repositories, as the RPM install will install CRI-O as long as it can find it).

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

RPMs will be placed in `./packaging/rpm/\_rpmbuild/RPMS/`. There are two RPMs that will be required to install:

```
packaging/rpm/_rpmbuild/RPMS/noarch/microshift-selinux-*
packaging/rpm/_rpmbuild/RPMS/x86_64/microshift-*
```

### Installing the RPMs

```bash
sudo dnf localinstall -y packaging/rpm/_rpmbuild/RPMS/noarch/microshift-selinux-*
sudo dnf localinstall -y packaging/rpm/_rpmbuild/RPMS/x86_64/microshift-4.8.0-nightly.el8.x86_64.rpm
```

### Start CRI-O and MicroShift services

```bash
systemctl enable crio --now
systemctl enable microshift --now
```

Verify that MicroShift is running.

```sh
export KUBECONFIG=/var/lib/microshift/resources/kubeadmin/kubeconfig
kubectl get pods -A
```

You can stop MicroShift service with systemd

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
