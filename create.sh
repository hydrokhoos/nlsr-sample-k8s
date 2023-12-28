#!/bin/sh

for yml in $(ls | grep yaml)
do
  kubectl apply -f $yml
done

echo ""
sleep 0.5

for nodeNum in {1..4}
do
  echo "== [$nodeNum] NFD & NLSR =="
  podName=$(kubectl get pods -o name | grep ndn-node$nodeNum)
  kubectl cp nfd.conf "${podName:4}":/usr/local/etc/ndn/nfd.conf
  kubectl exec deployment/ndn-node$nodeNum -- /bin/bash -c "ndnsec key-gen /node$nodeNum | ndnsec cert-install -";
  echo "start NFD"
  kubectl exec deployment/ndn-node$nodeNum -- /bin/bash -c "nfd-start 2> /nfd.log";

  kubectl cp nlsr-node$nodeNum.conf "${podName:4}":/
  echo "start NLSR"
  kubectl exec deployment/ndn-node$nodeNum -- /bin/bash -c "nlsr -f /nlsr-node$nodeNum.conf &"
  echo "=======\n"
done

for nodeNum in {1..4}
do
  echo "== [$nodeNum] FACE CREATE =="
  kubectl exec deployment/ndn-node$nodeNum -- /bin/bash -c "for neighbor in \$NEIGHBORS;do nfdc face create tcp4://\$neighbor;done"
  echo "=======\n"
done
