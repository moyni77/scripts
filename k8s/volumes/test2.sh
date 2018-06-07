kubectl delete deploy storage-pod
pod=$(kubectl get pod -l app=storage-pod -o json | jq .items[].metadata.name)
while [ "$pod" != "" ]
do
   echo Waiting for the pod to terminate $pod
   sleep 5
   pod=$(kubectl get pod -l app=storage-pod -o json | jq .items[].metadata.name)
done

kubectl create -f storage-pod.yml
pod=$(kubectl get pod -l app=storage-pod -o json | jq .items[].metadata.name)
pod=$( eval echo $pod )
echo $pod
status=$(kubectl get pods -l app=storage-pod -o json | jq -r .items[].status.phase)
while [ "$status" != "Running" ]
do
  kubectl get pods -l app=storage-pod
  sleep 5
  status=$(kubectl get pods -l app=storage-pod -o json | jq -r .items[].status.phase)
done

echo verify the content of /tmp/foo/foo/txt using kubectl exec -it ${pod}
kubectl exec -it ${pod} -- sh -c "cat /tmp/foo/foo.txt"
