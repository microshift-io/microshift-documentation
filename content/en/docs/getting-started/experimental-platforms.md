---
title: "Experimental platforms"
weight: 60
card:
  name: getting-started
  weight: 60
description: MicroShift has been deployed on various platforms. For testing and development purposes, an All-In-One MicroShift container image can run on Windows, MacOS, and Linux with Podman or Docker.
---

MicroShift has been deployed on various platforms. For testing and development purposes, an All-In-One
MicroShift container image can run on Windows, MacOS, and Linux with Podman or Docker.

It may be possible to run MicroShift on other systems, however they haven't been tested so you may run into issues.

## MicroShift All-In-One Image

MicroShift All-In-One (AIO) includes everything required to run MicroShift in a single container image.
This deployment mode is recommended for development and testing only. See here for [deploying MicroShift AIO]({{< ref "../deployment-guide/containerized.md#microshift-all-in-one-startup" >}})

## Limitation

On MacOS, running containerized MicroShift as non-root is not supported.
