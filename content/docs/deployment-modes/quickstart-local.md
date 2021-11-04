---
title: MicroShift QuickStart
tags:
  - quickstart
  - testing
draft: false
weight: 5
summary: MicroShift Local QuickStart
modified: "2021-11-03T16:25:07.422+01:00"
---

To give MicroShift a try, simply install a recent test version (we don't provide stable releases yet) on a Fedora-derived Linux distribution (we've only tested Fedora, RHEL, and CentOS Stream so far) using:

```sh
curl -sfL https://raw.githubusercontent.com/redhat-et/microshift/main/install.sh | bash
```

This will install MicroShift's dependencies (CRI-O) on the host, install a MicroShift systemd service and start it.

For convenience, the script will also add a new "`microshift`" context to your `$HOME/.kube/config`, so you'll be able to access your cluster using, e.g.:

```sh
kubectl get all -A --context microshift
```

or

```sh
kubectl config use-context microshift
kubectl get all -A
```

{{< warning >}}
When installing MicroShift on a system with an older version already installed, it is safest to remove the old data directory and start fresh:
{{< /warning >}}

```sh
rm -rf /var/lib/microshift && rm -r $HOME/.microshift
```
