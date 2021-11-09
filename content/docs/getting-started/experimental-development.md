---
title: Experimental Development
weight: 4
modified: "2021-11-04T11:25:47.657+01:00"
tags:
  - experimental
  - all-in-one
  - OSX
  - MacOS
  - ephemeral
  - Windows
summary: MicroShift has been deployed on various platforms and with an All-In-One image
---

## OSX

WIP: More Content Coming Soon

## Windows

WIP: More Content Coming Soon

## MicroShift All-In-One Image

MicroShift All-In-One includes everything required to run MicroShift in a single container image.
This deployment mode is recommended for development and testing only.

### Run MicroShift All-In-One as a Systemd Service

Copy `microshift-aio.service` unit file to `/etc/systemd` and the `microshift-aio` run script to `/usr/bin`

```bash
curl -o /etc/systemd/system/microshift-aio.service https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift-aio.service
curl -o /usr/bin/microshift-aio https://raw.githubusercontent.com/redhat-et/microshift/main/packaging/systemd/microshift-aio
```

Now enable and start the service. The `KUBECONFIG` location will be written to `/etc/microshift-aio/microshift-aio.conf`.
If the `microshift-data` podman volume does not exist, the systemd service will create one.

```bash
systemctl enable microshift-aio --now
source /etc/microshift-aio/microshift-aio.conf
```

Verify that MicroShift is running.

```sh
kubectl get pods -A
```

Stop `microshift-aio` service

```bash
systemctl stop microshift-aio
```

{{< note >}}
Stopping `microshift-aio` service _does not_ remove the Podman volume `microshift-data`. A restart will use the same volume.
{{< /note >}}

### Run MicroShift All-In-One Image Without Systemd

First, enable the following SELinux rule:

```bash
setsebool -P container_manage_cgroup true
```

Next, create a container volume:

```bash
sudo podman volume create microshift-data
```

The following example binds localhost the container volume to `/var/lib`

```bash
sudo podman run -d --rm --name microshift-aio --privileged -v /lib/modules:/lib/modules -v microshift-data:/var/lib  -p 6443:6443 microshift-aio
```

You can access the cluster either on the host or inside the container

### Access the Cluster Inside the Container

Execute the following command to get into the container:

```bash
sudo podman exec -ti microshift-aio bash
```

Inside the container, install `kubectl`:

```bash
export ARCH=$(uname -m |sed -e "s/x86_64/amd64/" |sed -e "s/aarch64/arm64/")
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/${ARCH}/kubectl" && \
chmod +x ./kubectl && \
mv ./kubectl /usr/local/bin/kubectl
```

Inside the container, run the following to see the pods:

```bash
export KUBECONFIG=/var/lib/microshift/resources/kubeadmin/kubeconfig
kubectl get pods -A
```

### Access the Cluster From the Host

#### Linux

```bash
export KUBECONFIG=$(podman volume inspect microshift-data --format "{{.Mountpoint}}")/microshift/resources/kubeadmin/kubeconfig
kubectl get pods -A -w
```

#### MacOS

```bash
docker cp microshift-aio:/var/lib/microshift/resources/kubeadmin/kubeconfig ./kubeconfig
kubectl get pods -A -w --kubeconfig ./kubeconfig
```

#### Windows

```bash
docker.exe cp microshift-aio:/var/lib/microshift/resources/kubeadmin/kubeconfig .\kubeconfig
kubectl.exe get pods -A -w --kubeconfig .\kubeconfig
```

## Build All-In-One Container Image

### Build With Locally Built Binary

```bash
make microshift-aio FROM_SOURCE="true"
```

### Build With Latest Released Binary Download

```bash
make microshfit-aio
```

## QuickStart Local Deployment for Testing Only

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

## Limitation

These instructions are tested on Linux, Mac, and Windows.
On MacOS, running containerized MicroShift as non-root is not supported on MacOS.
