---
title: Configuring MicroShift
tags:
  - config.yaml
  - environment variables
  - command line
  - configuration
  - config
  - configure
draft: false
card:
  name: user-documentation
  weight: 20
weight: 20
description: Configuration options with MicroShift
---


## Configuration

Microshift can be configured in three simple ways, in order of precedence: 
- Commandline arguments
- Environment variables
- Configuration file

An example configuration can be found [here](https://github.com/redhat-et/microshift/blob/main/test/config.yaml).

Below is a table of consisting of the configuration settings presently offered in MicroShift, along with the ways they can be set, what they mean, and their default values.

| MicroshiftConfig field | CLI Argument | Environment Variable | Configuration File | Meaning | Default |
| ---------------------- | ------------ | -------------------- | ------------------ | ------- | ------- |
| `DataDir` | `--data-dir` | `MICROSHIFT_DATADIR` | `.dataDir` | Data directory for MicroShift | `"~/.microshift/data"` |
| `LogDir` | `--log-dir` | `MICROSHIFT_LOGDIR` | `.logDir` | Directory to output logfiles to | `""` | 
| `LogVLevel` | `--v` | `MICROSHIFT_LOGVLEVEL` | `.logVLevel` | Log verbosity level | `0` |
| `LogVModule` | `--vmodule` | `MICROSHIFT_LOGVMODULE` | `.logVModule` | Log verbosity module | `""` | 
| `LogAlsotostderr` | `--alsologtostderr` | `MICROSHIFT_LOGALSOTOSTDERR` | `.logAlsotostderr` | Log into standard error as well | `false` | 
| `Roles` | `--roles` | `MICROSHIFT_ROLES` | `.roles` | Roles available on the cluster | `["controlplane", "node"]` |
| `NodeName` | `n/a` | `MICROSHIFT_NODENAME` | `.nodeName` | Name of the node to run MicroShift on | `os.Hostname()` |
| `NodeIP` | `n/a` | `MICROSHIFT_NODEIP` | `.nodeIP` | Node's IP | `util.GetHostIP()` |
| `Cluster.URL` | `n/a` | `n/a` | `.cluster.url` | URL that the cluster will run on | `"https://127.0.0.1:6443"` |
| `Cluster.ClusterCIDR` | `n/a` | `n/a` | `.cluster.clusterCIDR` | Cluster's CIDR | `"10.42.0.0/16"` |
| `Cluster.ServiceCIDR` | `n/a` | `n/a` | `.cluster.serviceCIDR` | Service CIDR | `"10.43.0.0/16"` |
| `Cluster.DNS` | `n/a` | `n/a` | `.cluster.dns` | Cluster's DNS server | `"10.43.0.10"` |
| `Cluster.Domain` | `n/a` | `n/a` | `.cluster.domain` | Cluster's domain | `"cluster.local"` |
| `ConfigFile` | `--config` | `n/a` | `n/a` | Path to a config file used to populate the rest of the values | `"~/.microshift/config.yaml"` if the file exists, else `/etc/microshift/config.yaml` if it exists, else `""` | 
