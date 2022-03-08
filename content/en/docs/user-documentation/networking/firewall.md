---
title: "Firewall"
weight: 20
description: Firewall considerations for MicroShift
card:
  name: networking
  weight: 20
---

MicroShift does not require a firewall to run, but it's recommended. In the case of
using firewalld the following ports should be considered:

| Port(s)     | Protocol(s) | Description                                                  |
| ----------- | ----------- | ------------------------------------------------------------ |
| 80          | `TCP`       | HTTP port used to serve applications through the OpenShift router. |
| 443         | `TCP`       | HTTPS port used to serve applications through the OpenShift router. |
| 6443        | `TCP`       | HTTPS API port for the MicroShift API |
| 5353        | `UDP`       | [mDNS](../mdns/) service to respond for OpenShift route mDNS hosts |
| 30000-32767 | `TCP/UDP`   | Port range reserved for NodePort type of services, can be used to expose applications on the LAN |

Additionally pods need to be able to contact the internal coreDNS server, a way
to allow such connectivity is the following, assuming the PodIP range is `10.42.0.0/16`

`sudo firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16`

## Firewalld
An example for enabling firewalld and opening all the above mentioned ports is:

```Bash
sudo dnf install -y firewalld
sudo systemctl enable firewalld --now
sudo firewall-cmd --zone=trusted --add-source=10.42.0.0/16 --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=6443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=5353/udp --permanent
sudo firewall-cmd --zone=public --add-port=30000-32767/tcp --permanent
sudo firewall-cmd --zone=public --add-port=30000-32767/udp --permanent
sudo firewall-cmd --reload
```