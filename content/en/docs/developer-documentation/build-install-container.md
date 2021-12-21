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

Build the MicroShift container:

```Bash
make microshift
```

Build the MicroShift AIO container:

```Bash
make microshift-aio
```
## Tagging the Image

It is necessary to tag the image as latest to ensure that the newly created image is used when starting MicroShift with systemd.

```Bash
IMAGE=$(podman images | grep micro | awk '{print $3}')
podman tag ${IMAGE} quay.io/microshift/microshift:latest
```



## Running the MicroShift Containers

Now follow the [Getting Started]({{< ref "/docs/getting-started/" >}}) respective section of the User Documentation, substituting the released image in the documentation with your local image.
