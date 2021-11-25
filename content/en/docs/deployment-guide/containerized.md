---
title: MicroShift containerized
tags:
  - container
  - docker
  - podman
draft: false
content_type: concept
card:
  name: deployment-guide
  weight: 10
weight: 10
description: Install and run MicroShift from a Linux container
---

<!-- overview -->

Install and run MicroShift from a Linux container

<!-- body -->

### When to Use

MicroShift containerized is convenient for testing Kubernetes workloads and for application development.
Deployed with Podman and managed with Systemd, MicroShift containerized also
provides automatic updates using [Podman's Auto-Update feature](https://docs.podman.io/en/latest/markdown/podman-auto-update.1.html).

More about MicroShift Auto-Updates with Podman [here]({{< relref "#auto-update-on-demand-via-podman" >}})

### Prerequisites

- CRI-O service must be running on the host
- Before running MicroShift as a systemd service, ensure to update the host `crio-bridge.conf` as

```bash
$ cat /etc/cni/net.d/crio-bridge.conf
{
    "cniVersion": "0.4.0",
    "name": "crio",
    "type": "bridge",
    "bridge": "cni0",
    "isGateway": true,
    "ipMasq": true,
    "hairpinMode": true,
    "ipam": {
        "type": "host-local",
        "routes": [
            { "dst": "0.0.0.0/0" }
        ],
        "ranges": [
            [{ "subnet": "10.42.0.0/24" }]
        ]
    }
}
```

### Deployment Architecture

- **Containerized**

  - MicroShift binary runs in Podman container
  - CRI-O Systemd service runs directly on the host.
  - Data is stored at `/var/lib/microshift` and `/var/lib/kubelet`

- **Containerized All-In-One**
  - Testing and Development only
  - MicroShift binary and CRI-O service run within a Podman container.
  - Data is stored in a podman volume, `microshift-data`

### Systemd service

- [MicroShift-Containerized Unit File](https://github.com/redhat-et/microshift/blob/main/packaging/systemd/microshift-containerized.service)
- [MicroShift-All-In-One Unit File](https://github.com/redhat-et/microshift/blob/main/packaging/systemd/microshift-aio.service)

{{< warning >}}
MicroShift All-In-One is meant for testing and development only.
{{< /warning >}}

### Run MicroShift Container With Systemd

Copy the unit file to `/etc/systemd/system` and the run script to `/usr/bin`

#### MicroShift Containerized

```bash
curl -o /etc/systemd/system/microshift.service https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift-containerized.service
curl -o /usr/bin/microshift-containerized https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift-containerized
```

#### MicroShift All-In-One

```bash
curl -o /etc/systemd/system/microshift.service https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift-aio.service
curl -o /usr/bin/microshift-aio https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift-aio
```

Now enable and start the services

#### MicroShift Containerized Startup

```bash
sudo systemctl enable crio --now
sudo systemctl enable microshift --now
export KUBECONFIG=/var/lib/microshift/resources/kubeadmin/kubeconfig
```

#### MicroShift All-In-One Startup

```bash
sudo systemctl enable microshift --now
source /etc/microshift-aio/microshift-aio.conf # aio data-dir is a podman volume
```

Verify that MicroShift is running.

```sh
kubectl get pods -A
```

You can stop MicroShift service with systemd

```bash
systemctl stop microshift
```

{{< note >}}

- **containerized** data at `/var/lib/microshift` and `/var/lib/kubelet`, will not be deleted upon stopping services.
- **all-in-one** podman volume `microshift-data` will not be destroyed upon stopping the services.

Upon a restart, the cluster state will persist as long as the storage is intact.
{{< /note >}}

Check MicroShift with

```bash
sudo podman ps
sudo critcl ps
```

To access the cluster on the host or inside the container

### Access the cluster inside the container

Execute the following command to get into the container:

```bash
sudo podman exec -ti microshift bash
```

Inside the container, run the following to see the pods:

```bash
export KUBECONFIG=/var/lib/microshift/resources/kubeadmin/kubeconfig
kubectl get pods -A
```

For more on running MicroShift, refer to the [user documentation]({{< ref "/docs/user-documentation/_index.md" >}})

## Auto-Update on demand via Podman

Since Podman 3.4, Podman enables users to automate container updates using what are called auto-updates. On a high level, you can configure Podman to check the availability of new images for auto-updates, pull down these new images if needed, and restart the containers.

### Configuring Podman auto-updates

To ensure Podman is checking the fully qualified image path for new images and download them, the systemd file adds a label `--label "io.containers.autoupdate=registry"` to the `microshift` container. The container unit files in the [MicroShift repository](https://github.com/redhat-et/microshift/tree/main/packaging/systemd) are configured for auto-updates.

```bash
ExecStart=/usr/bin/podman run \
--cidfile=%t/%n.ctr-id \
--cgroups=no-conmon \
--rm -d --replace \
--sdnotify=container \
--label io.containers.autoupdate=registry \
--privileged --name microshift \
-v /var/run:/var/run -v /sys:/sys:ro -v /var/lib:/var/lib:rw,rshared -v /lib/modules:/lib/modules -v /etc:/etc\
-v /run/containers:/run/containers -v /var/log:/var/log \
-e KUBECONFIG=/var/lib/microshift/resources/kubeadmin/kubeconfig \
quay.io/microshift/microshift:latest
```

### Testing auto-updates

Podman `auto-update` command will look for containers with the label and a systemd service file as described above. If the command finds one container, it will check for a new image, download it, restart the container service.

```bash
sudo podman auto-update --dry-run

UNIT                              CONTAINER                                IMAGE                                                                           POLICY      UPDATED
microshift  2f7fa3962ee0 (microshift)  quay.io/microshift/microshift:4.7.0-0.microshift-2021-08-31-224727-linux-amd64  registry    false

```

The `--dry-run` feature allows you to assemble information about which services, containers, and images need updates before applying them. To apply them do

```bash
sudo  podman auto-update
```
