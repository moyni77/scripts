#
# Create a POD which accesses a PV and put some data there
#
kubectl create -f nfs-pv.yml
kubectl create -f nfs-pvclaim.yml
kubectl create -f storage-pod.yml

pod=$(kubectl get pod -l app=storage-pod -o json | jq .items[].metadata.name)
pod=$( eval echo $pod )
echo waiting for $pod to start && sleep 10

#
# put some data in the PV
#

kubectl exec -it ${pod} -- sh -c "echo line 1 >> /tmp/foo/foo.txt"
kubectl exec -it ${pod} -- sh -c "echo line 2 >> /tmp/foo/foo.txt"
kubectl exec -it ${pod} -- sh -c "echo line 3 >> /tmp/foo/foo.txt"

