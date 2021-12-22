---
title: "Building and Installing the MicroShift Containers"
tags:
  - develop
  - build
  - container
  - aio
draft: false
weight: 30
card:
  name: developer-documentation
  weight: 30
description: Building and installing the MicroShift and MicroShift AIO containers for local development
---
## Building the MicroShift Containers

Install `podman` if not yet installed:

```Bash
sudo dnf install -y podman
```

Clone the repository and `cd` into it:

```Bash
git clone https://github.com/redhat-et/microshift.git
cd microshift
```

Build the MicroShift image:

```Bash
make microshift
```

Build the MicroShift bundled (All-In-One) image:

```Bash
make microshift-aio
```
## Tagging the Image

After building the MicroShift image, the `podman tag` command can be used to modify the image name to suit your needs. See the example below.

```Bash
IMAGE=$(podman images | grep micro | awk '{print $3}')
podman tag ${IMAGE} quay.io/microshift/microshift:latest
```

## Running the MicroShift Containers

Depending on which image version you built, follow the documentation to run the image.

{{< tabs >}}
{{% tab name="MicroShift Containerized" %}}

Follow [Getting Started with MicroShift Containerized]({{< ref "/docs/getting-started/_index.md#launch-microshift-with-podman-and-systemd" >}})    
Substitute the image name:tag in the systemd unit file at `/etc/system/systemd/microshift.service` with the newly built image name:tag.

{{% /tab %}}
{{% tab name="MicroShift Bundled Image (All-In-One)" %}}

Follow [Using MicroShift for Application Development]({{< ref "/docs/getting-started/_index.md#using-microshift-for-application-development" >}})    
Substitute the image name:tag in the podman command with the newly built image name:tag.


{{% /tab %}}
{{< /tabs >}}
