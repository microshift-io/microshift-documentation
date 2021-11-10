---
title: Configuring MicroShift
tags:
  - config.yaml
  - environment variables
  - command line
draft: true
weight: 3
summary: Configuration options with MicroShift
modified: "2021-11-03T16:24:11.538+01:00"
---

<!-- 
todo: 
- logging 
-->

## Configuration

Microshift can be configured in three simple ways, in order of precedence: 
- Commandline arguments
- Environment variables
- Configuration file

Values are passed in to modify the `MicroshiftConfig` defined in `pkg/config/config.go`. 

#### Configuration File

The config file is a `yaml` which has the fieldnames of the struct written in yaml format:

```yaml
# to set MicroshiftConfig.NodeName:
nodeName: anonymous-node-32

# to set MicroshiftConfig.Cluster.DNS:
cluster:
  dns: '1.2.3.4'
```

#### Environment Variables

Microshift reads environment variables as config settings if they are in the following format: 

```bash
# sets MicroshiftConfig.NodeName
export MICROSHIFT_NODENAME="anonymous-node-32"

# sets Microshift.LogVLevel
export MICROSHIFT_LOGVLEVEL=3
``` 
*Note*: Currently, you cannot use environment variables to set values for fields in structs 
that are nested within MicroshiftConfig; only top-level fields are allowed. 

#### Commandline Arguments

At the moment, only a subset of the Microshift config can be set through the commandline:

| MicroshiftConfig field | CLI Argument | 
| ---------------------- | ------------ |
| `DataDir` | `--data-dir` |
| `LogDir` | `--log-dir` |
| `LogVLevel` | `--v` |
| `LogVModule` | `--vmodule` |
| `LogAlsotostderr` | `--alsologtostderr` |
| `Roles` | `--roles` |
| `ConfigFile` | `--config` |


### Configuration Options

#### Changing the API Server Port 

To change the port for the API server, you must set the cluster URL in the config file:

```yaml
cluster:
  url: 'https://127.0.0.1:1234'
```
