#
# delete existing resources
#
pod=$(kubectl get pod -l app=storage-pod -o json | jq .items[].metadata.name)
if [ "$pod" != "" ]
then
  kubectl delete deploy storage-pod
  while [ "$pod" != "" ]
  do
     echo Waiting for the pod to terminate $pod
     sleep 5
     pod=$(kubectl get pod -l app=storage-pod -o json | jq .items[].metadata.name)
  done
fi
kubectl get pvc nfs-pvc1 2>/dev/null && kubectl delete pvc nfs-pvc1 
kubectl get pv nfs-pv01  2>/dev/null && kubectl delete pv nfs-pv01
