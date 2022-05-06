---
title: Offline/disconnected container images
draft: false
weight: 9
tags:
  - Container Storage
  - Disconnected
description: Offline containers are containers which are stored in the operating system image, and made available to `cri-o` via the `/etc/container/storage.conf` `additionalimagestores` list.
---
## What are offline container images

Offline containers are containers which are stored in the operating system image,
and made available to `cri-o` via the `/etc/container/storage.conf` `additionalimagestores`
list.

Those container images are accesible for `cri-o` to create containers. Those images
cannot be deleted, but newer versions of those containers can be downloaded normally,
which `cri-o` will store in the general R/W container storage of the system.

## When to use offline container images

Offline containers are useful when the Edge device will have restricted connectivity,
or no connectivity at all. Those containers are also helpful to improve general MicroShift
and application startup on first boot, since no images need to be downloaded from the
network and the applications are readily available to `cri-o`

## RPM packaging of container images

RPM packaging of container images into read-only container storage is offered via the
[`paack`](https://github.com/redhat-et/microshift/blob/main/packaging/rpm/paack.py) tool
as an experimental method to allow users to create ostree images containing the desired containers.
`RPM` was not designed for storing files with numeric uids/gids, or containing extended attributes,
although several workarounds allow this we are looking for better ways to provide this.

## Offline MicroShift containers images

MicroShift uses a set of containers for the minimal components which can be installed
on the operating system image, those are published [here](https://copr.fedorainfracloud.org/coprs/g/redhat-et/microshift-containers/), and can also be manually built using:  `packaging/rpm/make-microshift-images-rpm.sh`.

To install the MicroShift container images you can use:
```bash
curl -L -o /etc/yum.repos.d/microshift-containers.repo \
          https://copr.fedorainfracloud.org/coprs/g/redhat-et/microshift-containers/repo/fedora-35/group_redhat-et-microshift-containers-fedora-35.repo

rpm-ostree install microshift-containers
````

Or simply install that repository and package from an os build blueprint.


## How package your application and manifests as rpms for offline container storage

To package workload application container images we provide `packaging/rpm/paack.py`.
This tool accepts a yaml definition, for which an example can be found
[here](https://github.com/redhat-et/microshift/blob/main/packaging/rpm/example-user-containers.yaml).

The tool can produce an srpm, rpm, or push a build to a copr repository.

Some example usages:

```bash
./paack.py rpm example-user-containers.yaml centos-stream-9-aarch64
```

The target os is not important (`centos-stream-9`) but we need one os target
compatible with the destination architecture.

```bash
./paack.py srpm example-user-containers.yaml
```

The produced `srpm` format contains the repository binaries and manifests for each architecture,
then the build system unpacks the specific architecture for the build. The post install step
of rpm configures the additionalimagestores in `/etc/container/storage.conf`

```bash
./paack.py copr example-user-containers.yaml mangelajo/my-app-containers
```
