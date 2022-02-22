---
title: "Differences between MicroShift and OKD"
weight: 100
main_menu: true
content_type: concept
description: "Addressing some innate differences between OKD and MicroShift."
---
# Differences Between OKD and MicroShift

The design goals behind MicroShift diverge from those of OKD as a necessity of the very different operating environments each project targets.  Namely, OKD achieves the goal of providing a full-stack, self-managed container appliction platform, targeting developer and operations-centric use cases on cloud infrastructure. MicroShift aims to provide an minimal OpenShift experience on small form factor, often headless devices with as conservative a resource overhead as possible. To further the project's goals, the MicroShift team has reduced OKD's feature set to remove functionality not well suited for the edge use cases.

## Deployment

For OKD, [openshift-install](https://github.com/openshift/okd#getting-started) automates cluster deployment from the hardware provisioning up to cluster installation.  The tool typically runs remotely and can execute against a variety of cloud infrastructures and baremetal.  Importantly, the installer requires a reliable and speedy network connection throughout it's runtime.  Edge operating environments cannot be assumed to provide the same level of network reliability though.  To adapt to this, MicroShift is deployed as a single binary which encapsulates the OKD control-plane, and is run as an application on the operating system or in a container.  By deploying MicroShift as you would any other app, we're able to streamline deployment, updates, and rollbacks by distributing the bits as rpms or container images.  This is also well suited to atomic OS's, such as those built on [rpm-ostree](https://coreos.github.io/rpm-ostree/).  In such cases, MicroShift can be packed into a new OS layer to be loaded onto devices.

## OKD's Managed Control

The largest feature (in terms of runtime objects) that we've trimmed are the built-in OKD control-plane operators.  Running an operator for each control-plane componetn is *very* costly at small scale.  Operators are built on the [operator-framework](https://operatorframework.io/), which provides a wonderful toolset and boilerplate for orchestrating application lifecycle management.  However, MicroShift compiles the control-plane into a single binary. This deliberate design means that the control-plane applications are not managed through the Kubernetes API, making the role of their operators moot.  A beneficial side-effect of this design is a measurable reduction of redundant code (operator boilerplate) and a lower runtime overhead.  For most cases, we do not expect this do impact application portability.  However it is worth documenting the OKD APIs that are and are not shipped with MicroShift.

#### Included OKD APIs

| Group                               | Kind                       |
| ----------------------------------- | -------------------------- |
| authorization.openshift.io          | rolebindingrestrictions    |
| config.openshift.io                 | builds                     |
|                                     | images                     |
|                                     | proxies                    |
| imageregistry.operator.openshift.io | configs                    |
| operator.openshift.io               | imagecontentsourcepolicies |
| quota.openshift.io                  | clusterresourcequotas      |
| security.openshift.io               | securitycontextconstraints |

#### Excluded OKD APIs

|Group|Kind|
|---|---|
|apiserver.openshift.io|apirequestcounts|
|autoscaling.openshift.io|clusterautoscalers|
||machineautoscalers|
|cloudcredential.openshift.io|credentialsrequests|
|config.openshift.io|apiservers|
||authentications|
||clusteroperators|
||clusterversions|
||consoles|
||dnses|
||featuregates|
||infrastructures|
||ingresses|
||networks|
||oauths|
||operatorhubs|
||projects|
||schedulers|
|console.openshift.io|consoleclidownloads|
||consoleexternalloglinks|
||consolelinks|
||consolenotifications|
||consoleplugins|
||consolequickstarts|
||consoleyamlsamples|
|controlplane.operator.openshift.io|podnetworkconnectivitychecks|
|helm.openshift.io|helmchartrepositories|
|imageregistry.operator.openshift.io|imagepruners|
|ingress.operator.openshift.io|dnsrecords|
|k8s.cni.cncf.io|network-attachment-definitions|
|machineconfiguration.openshift.io|containerruntimeconfigs|
||controllerconfigs|
||kubeletconfigs|
||machineconfigpools|
||machineconfigs|
|machine.openshift.io|machinehealthchecks|
||machinesets|
||machines|
|metal3.io|baremetalhosts|
||provisionings|
|migration.k8s.io|storagestates|
||storageversionmigrations|
|monitoring.coreos.com|alertmanagerconfigs|
||alertmanagers|
||podmonitors|
||probes|
||prometheuses|
||prometheusrules|
||servicemonitors|
||thanosrulers|
|network.openshift.io|clusternetworks|
||egressnetworkpolicies|
||hostsubnets|
||netnamespaces|
|network.operator.openshift.io|egressrouters|
||operatorpkis|
|operator.openshift.io|authentications|
||cloudcredentials|
||clustercsidrivers|
||configs|
||consoles|
||csisnapshotcontrollers|
||dnses|
||etcds|
||ingresscontrollers|
||kubeapiservers|
||kubecontrollermanagers|
||kubeschedulers|
||kubestorageversionmigrators|
||networks|
||openshiftapiservers|
||openshiftcontrollermanagers|
||servicecas|
||storages|
|operators.coreos.com|catalogsources|
||clusterserviceversions|
||installplans|
||operatorconditions|
||operatorgroups|
||operators|
||subscriptions|
|samples.operator.openshift.io|configs|
|security.internal.openshift.io|rangeallocations|
|snapshot.storage.k8s.io|volumesnapshotclasses|
||volumesnapshotcontents|
||volumesnapshots|
|tuned.openshift.io|profiles|
||tuneds|
|whereabouts.cni.cncf.io|ippools|
||overlappingrangeipreservations|

