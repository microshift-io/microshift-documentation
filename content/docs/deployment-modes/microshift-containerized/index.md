---
title: MicroShift Containerized
tags:
  - container
  - docker
  - podman
draft: false
weight: 3
summary: Deploy MicroShift from a linux container and run as a systemd service.
---

MicroShift can be run from a linux container with the host CRI-O service and managed with a systemd service.

## Pre-requisites

* CRI-O service must be running on the host
* Before runnng microshift as a systemd service, ensure to update the host `crio-bridge.conf` as

```bash
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

## Run MicroShift as a systemd service

Copy microshift unit file to `/etc/systemd/system` and the microshift-containerized run script to `/usr/bin`

```bash
curl -o /etc/systemd https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift
curl -o /usr/bin/microshift-containerized https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift-containerized
```

Now enable and start the service. The KUBECONFIG location will be written to `/var/lib/microshift/resources/kubeadmin/kubeconfig`.

```bash
sudo systemctl enable microshift --now
```

Verify that microshift is running.

```sh
export KUBECONFIG=/var/lib/microshift/resources/kubeadmin/kubeconfig
kubectl get pods -A
```

Stop microshift service

```bash
systemctl stop microshift
```

You can check microshift via

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

### Access the cluster on the host

#### Linux

```bash
export KUBECONFIG=/var/lib/microshift/resources/kubeadmin/kubeconfig
kubectl get pods -A -w
```

## Auto-Update on demand via Podman

Since Podman 3.4, Podman enables users to automate container updates using what are called auto-updates. On a high level, you can configure Podman to check the availability of new images for auto-updates, pull down these new images if needed, and restart the containers.

### Configuring Podman auto-updates

To ensure Podman is checking the fully qualified image path for new images and download them, the systemd file adds a label `--label "io.containers.autoupdate=registry"` to the `microshift` container

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
quay.io/microshift/microshift:4.7.0-0.microshift-2021-08-31-224727-linux-amd64
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
