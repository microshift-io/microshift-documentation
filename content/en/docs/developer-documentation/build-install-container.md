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

## Running the MicroShift Containers

Now follow the [Getting Started](http://localhost:1313/docs/getting-started/) respective section of the User Documentation, substituting the released image in the documentation with your local image.
