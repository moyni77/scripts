kubectl create ns foo
kubectl -n foo apply -f service.yaml -f hostnames.yaml -f curlpod.yaml
kubectl -n foo exec -it curlpod -- sh -c 'curl hostnames'
kubectl -n foo exec -it curlpod -- sh -c 'nslookup hostnames'

and here is the expected result

[root@clh2-ansible busy]# kubectl create ns foo
namespace "foo" created
[root@clh2-ansible busy]# kubectl -n foo apply -f service.yaml -f hostnames.yaml -f curlpod.yaml
service "hostnames" created
deployment.extensions "hostnames" created
pod "curlpod" created
[root@clh2-ansible busy]# kubectl -n foo exec -it curlpod -- sh -c 'curl hostnames'
hostnames-7c496d87f-wwsgq
[root@clh2-ansible busy]# kubectl -n foo exec -it curlpod -- sh -c 'nslookup hostnames'
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      hostnames
Address 1: 10.96.41.179 hostnames.foo.svc.cluster.local

