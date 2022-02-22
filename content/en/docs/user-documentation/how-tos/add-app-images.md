---
title: Add images to container storage
draft: false
weight: 9
tags:
  - Container Storage
  - Disconnected
description: To add application images to container store for microshift to access on limited or no network, build rpm using microshift-app-images.spec
---

## How to build rpm using microshift-app-images.spec

To add application images to container store for microshift to access on limited or no network, build rpm `microshift-app-images.spec` using 

```sh
cd ./packaging/rpm/
./make-microshift-app-images-rpm.sh images /var/lib/usersimages ~/rpmbuild/
```

where:
- `$1` file path containing full registry path of the user images to be pulled, per line. 

```sh
cat ./images
quay.io/bitnami/nginx@sha256:275c5dbb577b61de9a42c5b8eaecafd35ec6bb8cd588e5df30b8ec7d8e0e3a10
quay.io/jaegertracing/all-in-one:latest
```

- `$2` container storage dir path 
- `$3 ` RPMBUILD_DIR

The above command will create `microshift-app-images.spec` at `~/rpmbuild/SPECS/`. The binary rpm will be created at `~/rpmbuild/RPMS/`

Install the rpm on the target machine to access the application images. The rpm built above will have two images `quay.io/bitnami/nginx@sha256:275c5dbb577b61de9a42c5b8eaecafd35ec6bb8cd588e5df30b8ec7d8e0e3a10` and `quay.io/jaegertracing/all-in-one:latest` at `/var/lib/usersimages` on the target machine. The new container storage path `/var/lib/usersimages` will be added `/etc/containers/storage.conf` once  `microshift-app-images.rpm` is installed on the target machine.