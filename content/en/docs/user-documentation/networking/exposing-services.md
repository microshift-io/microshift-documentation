---
title: "Exposing Services"
weight: 10
description: Exposing services in MicroShift.
card:
  name: networking
  weight: 10
---

Services deployed in MicroShift can be exposed in multiple ways. 

# Routes and Ingresses
By default an OpenShift router is created and exposed on host network ports 80/443.
`Routes`or `Ingresses` can be used to expose HTTP or HTTPS services through the router.

### Example
```bash
oc create deployment nginx --image=nginxinc/nginx-unprivileged:stable-alpine
oc expose deployment nginx --port=8080
oc expose service/nginx --hostname=my-hostname.com

# assuming my-hostname.com being mapped to the MicroShift node IP
curl http://my-hostname.com
```

### Route with mDNS host example
The hostname of a route can be a mDNS (.local) hostname, which would be then
announced via mDNS, see the [mDNS](../mdns/) section for more details.

```bash
oc expose service/nginx --hostname=my-hostname.local
curl http://my-hostname.local
```

# Service of type NodePort
NodePort type of services expose services over a dedicated port on all the cluster
nodes, such port is routed internally to the active pods backing the service.

### Example
```bash
oc create deployment nginx --image=nginxinc/nginx-unprivileged:stable-alpine
oc expose deployment nginx --type=NodePort --name=nodeport-nginx --port 8080
NODEPORT=$(oc get service nodeport-nginx -o jsonpath='{.spec.ports[0].nodePort}')
IP=$(oc get node -A -o jsonpath='{.items[0].status.addresses[0].address}')
curl http://$IP:$NODEPORT/
```

For using `NodePort` services open the 30000-32767 port range , see the 
[firewall](../firewall/) section.

# Service of type LoadBalancer
Services of type `LoadBalancer` are not supported yet, this kind of service is normally backed
by a load balancer in the underlying cloud.

Multiple alternatives are being explored to provide LoadBalancer VIPs on the LAN.
