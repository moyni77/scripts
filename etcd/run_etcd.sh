#
# the list of UCP Vms with their IP adresses
#
nodes=(clh-ucp01 clh-ucp02 clh-ucp03)
node_ips=(10.60.59.11 10.60.59.12 10.60.59.13)

size=${#nodes[@]}
initial_cluster=""
for ((i=0; i<$size; i++))
do
  initial_cluster="${initial_cluster},${nodes[$i]}=http://${node_ips[$i]}:2380"
done
initial_cluster=${initial_cluster:1}

echo initial_cluster=$initial_cluster


node=-1
nodename=$(hostname -s)
for ((i=0; i<$size; i++))
do
  if [ $nodename == ${nodes[$i]} ]
  then
    node=$i
  fi 
done

if [ $node == -1 ]
then
 echo this procedure must be run on one of ${nodes[@]}
 exit
fi

node_ip=${node_ips[$node]}
node=${nodes[$node]}

docker run -d \
  -p 2379:2379 \
  -p 2380:2380 \
  --restart=always \
  --name etcd_${node} \
  quay.io/coreos/etcd:latest \
    /usr/local/bin/etcd \
    --name ${node} \
    --initial-advertise-peer-urls http://${node_ip}:2380 \
    --listen-peer-urls http://0.0.0.0:2380 \
    --listen-client-urls http://0.0.0.0:2379 \
    --advertise-client-urls http://${node_ip}:2379 \
    --initial-cluster-token etcd-cluster-1 \
    --initial-cluster ${initial_cluster} \
    --initial-cluster-state new
