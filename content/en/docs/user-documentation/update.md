---
title: "Updating Microshift"
weight: 30
tags:
  - update
  - upgrade
description: "How to update an installed Microshift instance"
---


## Updating Microshift

The following steps will update an installed Microshift instance. Follow the steps for the method you used to install Microshift.

{{< tabs >}}
{{% tab name="Podman" %}}
To update MicroShift on Podman, run:

```Bash
sudo podman pull quay.io/microshift/microshift:latest
sudo systemctl restart microshift
```

{{% /tab %}}
{{% tab name=".rpm" %}}
To update MicroShift on an rpm-based host, run:

```Bash
sudo dnf update -y microshift
sudo systemctl restart microshift
```

{{% /tab %}}
{{< /tabs >}}
