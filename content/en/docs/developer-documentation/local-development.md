---
title: "Build and install"
tags:
  - develop
  - build
  - vagrant
draft: false
card:
  name: developer-documentation
  weight: 10
weight: 10
description: Building and running MicroShift for local development
---

### Build Dependencies

Install the required dependencies:

```sh
# Fedora/CentOS
sudo dnf install --enablerepo=powertools \
    git \
    make \
    golang \
    glibc-static

# Ubuntu
sudo apt install \
    git \
    build-essential \   # provides Make
    golang-go \
    glibc
```

{{< note >}}
If building containerized, will need to install podman (or Docker), find the appropriate guide for your respective system:
[Install Podman](https://podman.io/getting-started/installation)
If Docker is preferred, be sure that it is installed on your system.
{{< /note >}}

Clone the repository and cd into it:

```sh
git clone https://github.com/redhat-et/microshift.git
cd microshift
```

### Installing CRI-O

MicroShift containerized and RPM require that CRI-O is installed.
Steps to install CRI-O on Centos8 and Fedora are below.
More information on installing CRI-O lives [here](https://github.com/cri-o/cri-o/blob/main/install.md).

```bash
export OS=CentOS_8_Stream
export VERSION=1.22
```

#### Centos8Stream

```bash
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/$OS/devel:kubic:libcontainers:stable.repo
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo
sudo dnf install cri-o
```

#### Fedora 31 or later

```
sudo dnf module enable cri-o:$VERSION
sudo dnf install cri-o
```

### Containerized Build

Podman and Quay are used here, substitute `docker` for `podman` and/or `docker.io` for `quay.io` if preferred.

```sh
make microshift
```

### Containerized All-In-One Build

{{< warning >}}
Containerized All-In-One MicroShift is meant for testing and development only.
{{< /warning >}}

For testing and development convenience, an All-In-One image that includes everything required to run MicroShift can be built.

In the All-In-One deployment, CRI-O runs _inside_ the container rather than directly on the host.

To build this All-In-One image with your local branch:

```
FROM_SOURCE=true make microshift-aio
```

{{< note >}}
List the image and use podman tag to push the image to a registry of choice.

```sh
podman tag <image> quay.io/username/microshift:tag
podman push quay.io/username/microshift:tag
```

{{< /note >}}

### Deploying MicroShift Containerized

Now follow the [Containerized Deployment steps -podman-]({{< ref "/docs/getting-started/#deploying-microshift-to-edge-devices" >}}) or 
[Containerized All-In-One Deployment steps]({{< ref "/docs/getting-started/#using-microshift-for-application-development" >}})
and substitute the locally built image for the latest released image in the documentation.

### Building Non-Containerized

MicroShift can be built directly on the host. When developing non-containerized, is also necessary to build the required SELinux package.

Build the binary and configure SELinux with:

```bash
make build
sudo mv microshift /usr/local/bin/
cd packaging/selinux && sudo make install
```

{{< note >}}
When using RHEL ensure the system is registered and run the following before installing the prerequisites.

```sh
ARCH=$( /bin/arch )
sudo subscription-manager repos --enable "codeready-builder-for-rhel-8-${ARCH}-rpms"
```

{{< /note >}}

### Running MicroShift Locally

```bash
sudo microshift run
or
sudo microshift run -v=<log verbosity>
```

Now switch to a new terminal to access and use this development MicroShift cluster.
Refer to the [MicroShift user documentation]({{< ref "/docs/user-documentation/_index.md" >}})
