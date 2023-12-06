# nlsr-sample-k8s

## Overview
This repository provides a sample Kubernetes (K8s) deployment script for Named Data Networking (NDN) using NDN Link State Routing Protocol (NLSR).

![nlsr-sample-k8s.png](nlsr-sample-k8s.png)

## Deployment
1. Clone the repository and navigate to the project directory:
```bash
git clone https://github.com/hydrokhoos/nlsr-sample-k8s.git
cd nlsr-sample-k8s
```

2. Execute the deployment script:
```bash
./create.sh
```

3. Check NLSR status on a specific node:
```bash
kubectl exec deployment/ndn-node1 -- /bin/bash -c "nlsrc status"
```

## Provide Content
1. Create content (e.g. /sample.txt)
```bash
kubectl exec deployment/ndn-node1 -- /bin/bash -c "echo 'Hello, world!' > /sample.txt"
```

2. Advertise content using NLSR
```bash
kubectl exec deployment/ndn-node1 -- /bin/bash -c "nlsrc advertise /sample.txt"
```

3. Provide content
```bash
kubectl exec deployment/ndn-node1 -- /bin/bash -c "ndnputchunks /sample.txt < /sample.txt"
```

4. Request content from another node
```bash
kubectl exec deployment/ndn-node3 -- /bin/bash -c "ndncatchunks /sample.txt"
```

## Undeploy
To delete the deployments and associated resources:
```bash
kubectl delete -f ndn-node1.yaml
kubectl delete -f ndn-node2.yaml
kubectl delete -f ndn-node3.yaml
kubectl delete -f ndn-node4.yaml
```
