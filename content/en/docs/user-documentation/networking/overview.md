---
title: "Overview"
weight: 5
description: Overview of the MicroShift networking.
card:
  name: networking
  weight: 5
---

MicroShift uses the host configured networking, either statically configured
or via DHCP. In the case of dynamic addresses MicroShift will restart if an
IP change is detected during runtime.

Connectivity to the K8s API endpoint is provided in the default 6443 port on
the master host(s) IP addresses. If other services in the network must interact
with the MicroShift API connectivity should be performed in any of the following
ways:
  * DNS discovery, pre-configured on the network servers.
  * Direct IP address connectivity.
  * mDNS discovery via .local domain, see [mDNS](./mdns)

Conectivity between Pods is handled by the [CNI](./cni) plugin on the Pod network
range which defaults to `10.42.0.0/16` which can be modified via `Cluster.ClusterCIDR`
[configuration](../configuring/) parameter, see more details in the corresponding sections.

Connectivity to services of type ClusterIP is provided by the embedded `kube-proxy`
iptables-based implementation on the `10.43.0.0/16` range which can be modified via
`Cluster.ServiceCIDR` [configuration](../configuring/) parameter.

