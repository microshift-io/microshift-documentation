---
title: MicroShift and real-time Kernel
weight: 9
summary: MicroShift and real-time Kernel
tags:
  - MicroShift
  - real-time
  - kernel
description: Run your real-time enabled workloads on MicroShift running on a real-time Kernel.
draft: false
modified: "2022-05-19T18:14:03.755+01:00"
---

## MicroShift and real-time Kernel

Some of our edge workloads may benefit or require the use of a real-time Kernel. In this document we will cover how you can run MicroShift on a node running a real-time Kernel.

Even though the OS management and configuration is outside the scope of MicroShift we believe this doc may be helpful for users working with RT-enabled workloads.

### Getting RT Kernel in our nodes

In this section we will cover how to get an RT Kernel deployed on CentOS 8 Streams and RHEL 8. There are several OS systems out there, you can refer to official docs to get an RT Kernel deployed on other systems.

#### CentOS 8 Streams

1. SSH into your node and run the following commands:

  ~~~sh
  sudo dnf groupinstall RT --enablerepo rt
  sudo reboot
  ~~~

2. Once the node comes back, it should have booted with the RT kernel:

  ~~~sh
  Linux microshift 4.18.0-383.rt7.168.el8.x86_64 #1 SMP PREEMPT_RT Wed Apr 20 20:17:38 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
  ~~~

#### RHEL 8

1. SSH into your node and run the following commands:

  ~~~sh
  sudo dnf groupinstall RT --enablerepo rhel-8-for-x86_64-rt-rpms
  sudo reboot
  ~~~

2. Once the node comes back, it should have booted with the RT kernel:

  ~~~sh
  Linux microshift 4.18.0-372.9.1.rt7.166.el8.x86_64 #1 SMP PREEMPT_RT Mon Apr 18 10:44:25 EDT 2022 x86_64 x86_64 x86_64 GNU/Linux
  ~~~

### Running MicroShift on an RT Kernel

Once you have your node up and running with an RT Kernel you can follow the [Getting Started Guide](https://microshift.io/docs/getting-started/) to get MicroShift deployed on your favorite Linux distribution.

After MicroShift have been deployed on your node, if you run `oc get node -o wide` you should get something like this:

> :information_source: The output shows the Kernel information, and you can see that MicroShift is running on an RT Kernel.

~~~sh
$ oc get node -o wide

NAME         STATUS   ROLES    AGE   VERSION   INTERNAL-IP       EXTERNAL-IP   OS-IMAGE          KERNEL-VERSION                  CONTAINER-RUNTIME
microshift   Ready    <none>   13m   v1.21.0   192.168.122.152   <none>        CentOS Stream 8   4.18.0-383.rt7.168.el8.x86_64   cri-o://1.23.2
~~~

At this point you're ready to get your rt-enabled workloads running on MicroShift, happy hacking!