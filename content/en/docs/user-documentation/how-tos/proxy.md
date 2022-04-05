---
title: Deploying MicroShift behind Proxy
tags:
  - proxy
  - rpm
  - podman
  - cri-o
  - registry
draft: false
weight: 9
description: How to configure the host OS so MicroShift can work behind a proxy.
modified: "2021-11-10T12:40:37.755+01:00"
---

When deploying MicroShift behind a proxy, configure the host OS to use the proxy for both yum and CRI-O.

### Configuring HTTP(S) proxy for yum

To configure yum to use a proxy, add the following to `/etc/yum.conf`:

```sh
proxy=http://$PROXY_SERVER:$PROXY_SERVER
proxy_username=$PROXY_USER
proxy_password=$PROXY_PASSWORD
```

### Configuring HTTP(S) proxy for CRI-O or Podman

CRI-O and Podman are Go programs that use the built-in `net/http` package. To use an HTTP(S) proxy you need to set the `HTTP_PROXY` and `HTTPS_PROXY` environment variables and optionally the `NO_PROXY` variable to exclude a list of hosts from being proxied). For example, add the following to `/etc/systemd/system/crio.service.d/00-proxy.conf`:

```sh
[Service]
Environment=NO_PROXY="localhost,127.0.0.1,10.42.0.0/16,10.43.0.0/16"
Environment=HTTP_PROXY="http://$PROXY_USER:$PROXY_PASSWORD@$PROXY_SERVER:$PROXY_PORT/"
Environment=HTTPS_PROXY="http://$PROXY_USER:$PROXY_PASSWORD@$PROXY_SERVER:$PROXY_PORT/"
```

Restart CRI-O:

```sh
sudo systemctl restart crio
```