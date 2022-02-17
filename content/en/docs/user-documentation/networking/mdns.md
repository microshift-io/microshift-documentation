---
title: "mDNS"
weight: 30
description: embedded Multicast DNS support in microshift.
card:
  name: networking
  weight: 30
---

MicroShift includes an embedded mDNS server. mDNS is a protocol used to allow
name resolution and service discovery under a LAN using multicast.

This allows .local domains exposed by MicroShift to be discovered by other elements
on the Local Area Network.

mDNS is exposed on the `5353/UDP` port.

## Notes for Linux

mDNS resolution on Linux is provided by the avahi-daemon, for other Linux hosts to discover
MicroShift services, or for workers to locate the master node via mDNS, avahi should be enabled:

```bash
sudo dnf install -y nss-mdns avahi
hostnamectl set-hostname microshift-vm.local
systemctl enable --now avahi-daemon.service
```

By default only the minimal IPv4 mDNS resolver is implemented, that will only resolve TLD mDNS
domains like <hostname>.local, if you want to use hostnames in the form of <subdomain>.<domain>.local
you need to enable the full mDNS resolver on the host trying to resolve those dns entries:

```bash
echo .local > /etc/mdns.allow
echo .local. >> /etc/mdns.allow
sed -i 's/mdns4_minimal/mdns/g' /etc/nsswitch.conf
```