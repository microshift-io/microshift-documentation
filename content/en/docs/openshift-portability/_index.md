---
title: "Differences between MicroShift and OKD"
weight: 100
main_menu: true
content_type: concept
description: "Addressing some innate differences between OKD and MicroShift."
---
# Differences Between OKD and MicroShift

## App Portability

MicroShift is, by design, a trimmed down version of OKD 4.x and as such, comprimises are made to affect the resource footprint of the platform's runtime, streamlining of the platform's distribution, and to tune MicroShift to edge use-cases.  By and large, this should not impeded application portability between OKD 4.x and MicroShift, but it is worth noting key differences.

### Where's all the Operators?

The largest feature (in terms of runtime objects) that we've trimmed are the built-in OKD control-plane operators.  Running an operator for each control-plane componetn is *very* costly at small scale.  Operators are built on the [operator-framework](https://operatorframework.io/), which provides a wonderful toolset and boilerplate for orchestrating application lifecycle management.  However, MicroShift compiles the control-plane into a single binary. This deliberate design means that the control-plane applications are not managed through the Kubernetes API, making the role of their operators moot.  A beneficial side-effect of this design is a measurable reduction of redundant code (operator boilerplate) and a lower runtime overhead.  For most cases, we do not expect this do impact application portability.  However it is worth documenting the CRD APIs that are and are not shipped with MicroShift.

#### Included OKD CRDs

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

#### Excluded OKD CRDs

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

