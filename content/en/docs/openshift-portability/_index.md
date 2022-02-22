---
title: "Differences between MicroShift and OKD"
weight: 100
main_menu: true
content_type: concept
description: "Addressing some innate differences between OKD and MicroShift."
---
# Differences Between OKD and MicroShift

The design goals behind MicroShift diverge from those of OKD as a necessity of the very different operating environments each project targets.  Namely, OKD achieves the goal of providing a full-stack, self-managed container appliction platform, targeting developer and operations-centric use cases on cloud infrastructure. MicroShift aims to provide an minimal OpenShift experience on small form factor, often headless devices with as conservative a resource overhead as possible. To further the project's goals, the MicroShift team has reduced OKD's feature set to remove functionality not well suited for edge use cases.

## Deployment

MicroShift's deployment model differs significantly from OKD's.  [Openshift-install](https://github.com/openshift/okd#getting-started) fully automates OKD deployment on cloud or baremetal infrastructure and manages system dependencies and configuration.  It goes a long way to provide an easy to use and streamlined installation model for users.  MicroShift, being a single binary, can be installed atomically and managed like any other app.  This allows for a lot of flexibility in how the bits are deployed to devices, but places the burden system configuration on the user.  Distributing MicroShift via RPMs and container images enables us to alleviate some of this responsibility.  

Distributing an atomic Microshift binary also fulfills the goal of robust installs, updates and rollbacks. Simply replacing the MicroShift binary and restarting the service is all that's required.  This is makes MicroShift well suited to atomic OS's, such as those built on [rpm-ostree](https://coreos.github.io/rpm-ostree/), which provide intelligent update/rollback features.

## Operators

The largest feature (in terms of runtime objects) that do not satsify MicroShift's frugal resource requirements are the built-in OKD control-plane operators.  Running an operator for each control-plane componetn is *very* costly at small scale.  Operators are built on the [operator-framework](https://operatorframework.io/), which provides a wonderful toolset and boilerplate for orchestrating application lifecycle management.  However, MicroShift compiles the control-plane into a single binary. This deliberate design means that the control-plane applications are not managed through the Kubernetes API, making the role of their operators moot.  A beneficial side-effect of this design is a measurable reduction of redundant code (operator boilerplate) and a lower runtime overhead.  For most cases, we do not expect this do impact application portability.  However it is worth documenting the OKD APIs that are and are not shipped with MicroShift.

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

