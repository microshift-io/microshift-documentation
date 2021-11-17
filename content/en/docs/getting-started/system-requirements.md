---
title: "System requirements"
weight: 40
content_type: concept
card:
  name: getting-started
  weight: 40
tags:
  - requirements
  - system requirements
  - operating system
description: MicroShift host system requirements
---

## Minimum specs

In order to run MicroShift, you will need at least:

- 2 CPU cores
- 2GB of RAM
- ~124MB of free storage space for the MicroShift binary
- 64-bit CPU (although 32-bit is _technically_ possible, if you're up for the challenge)

For barebone development the minimum requirement is 3GB of RAM, though this can increase
if you are using resource-intensive development tools.

## OS Requirements

Currently, the MicroShift binary is known to be supported on the following Operating Systems:

- Fedora > 32
- CentOS 8 Stream
- RHEL 8
- RHEL 4 Edge
- CentOS 7
- Ubuntu 20.04

It is also possible to run a MicroShift image with Podman or Docker.
It may be possible to run MicroShift on other systems, however they haven't been tested so you may run into issues.
