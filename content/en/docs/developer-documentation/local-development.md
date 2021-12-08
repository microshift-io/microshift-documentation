---
title: "Building and Running MicroShift"
tags:
  - develop
  - build
  - binary
draft: false
card:
  name: developer-documentation
  weight: 10
weight: 10
description: Building and running the MicroShift binary for local development
---

## System Requirements

For building MicroShift you need a system with a minimum of

- a supported 64-bit CPU architecture (amd64, arm64, or riscv64)
- a supported Linux OS (RHEL 8, CentOS Stream 8, or Fedora 34+)
- 2 CPU cores
- 3GB of RAM
- 1GB of free storage space for MicroShift

## Building MicroShift

Install the build-time dependencies:

```Bash
command -v subscription-manager &> /dev/null \
    && sudo subscription-manager repos --enable "codeready-builder-for-rhel-8-$(uname -m)-rpms"
sudo dnf install -y --enablerepo=powertools git make golang
```

Clone the repository and `cd` into it:

```Bash
git clone https://github.com/redhat-et/microshift.git
cd microshift
```

Build MicroShift:

```Bash
make
```

## Running MicroShift

Install [CRI-O](https://github.com/cri-o/cri-o/blob/main/install.md):

```Bash
command -v subscription-manager &> /dev/null \
    && subscription-manager repos --enable rhocp-4.8-for-rhel-8-x86_64-rpms \
    || sudo dnf module enable -y cri-o:1.21
sudo dnf install -y crio cri-tools podman
sudo systemctl enable crio --now
```

Install the SELinux policies from RPM or build and install them from source:

```Bash
# from RPM
sudo dnf copr enable -y @redhat-et/microshift
sudo dnf install -y microshift-selinux

# from source
(cd packaging/selinux && sudo make install)
```

Run MicroShift using

```bash
sudo microshift run
```

Now switch to a new terminal to access and use this development MicroShift cluster.
Refer to the [MicroShift user documentation]({{< ref "/docs/user-documentation/_index.md" >}})

## Cleaning Up

To stop all MicroShift processes and wipe its state run:

```Bash
sudo hack/cleanup.sh
```
