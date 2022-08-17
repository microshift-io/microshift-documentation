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

- a supported 64-bit CPU architecture (amd64/x86_64, arm64, or riscv64)
- a supported Linux OS (RHEL 8, CentOS Stream, or Fedora 34+)
- 2 CPU cores
- 3GB of RAM
- 1GB of free storage space for MicroShift

## Building MicroShift

Install the build-time dependencies:

{{< tabs >}}
{{% tab name="RHEL" %}}

```Bash
sudo dnf install -y git make golang
```

{{% /tab %}}
{{% tab name="Fedora, CentOS Stream" %}}

```Bash
sudo dnf install -y git make golang
```

{{% /tab %}}
{{< /tabs >}}

<br/>

Clone the repository and `cd` into it:
{{< warning >}}
The available community documentation is not currently compatible with the latest MicroShift source code.
To build the latest MicroShift binary, follow the instructions in the [openshift/microshift GitHub repository](https://github.com/openshift/microshift).

Otherwise, use the `4.8.0-microshift-2022-04-20-141053` branch when working with the source repository and these instructions.
{{< /warning >}}

```Bash
git clone -b 4.8.0-microshift-2022-04-20-141053 https://github.com/openshift/microshift.git
cd microshift
```

Build MicroShift:

```Bash
# release build (without debug symbols)
make

# development build (with debug symbols)
make DEBUG=true
```

## Running MicroShift

MicroShift requires `CRI-O` to be installed and running on the host.    
Refer to [Getting Started: Install CRI-O]({{< ref "/docs/getting-started/_index.md#install-cri-o" >}})

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
sudo ./microshift run
```

Now switch to a new terminal to access and use this development MicroShift cluster.

- To install OpenShift and Kubernetes clients, follow [Getting Started: Install Clients]({{< ref "/docs/getting-started/_index.md#install-clients" >}}).

- To configure the kubeconfig, follow [Getting Started: Copy  Kubeconfig]({{< ref "/docs/getting-started/_index.md#copy-kubeconfig" >}}).

It is now possible to run `oc` or `kubectl` commands against the MicroShift environment.

Verify that MicroShift is running:

```sh
oc get pods -A
```

Refer to the [MicroShift user documentation]({{< ref "/docs/user-documentation/_index.md" >}})

## Cleaning Up

To stop all MicroShift processes and wipe its state run:

```Bash
sudo hack/cleanup.sh
```
