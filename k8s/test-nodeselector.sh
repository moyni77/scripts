cat <<EOF >/tmp/test-nodeselector.yml
apiVersion: v1
kind: Pod
metadata:
  name: test-nodeselector
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  nodeSelector:
    worker: "yes"
EOF

kubectl label nodes --overwrite=true clh-worker01.cloudra.local worker=yes
kubectl create -f /tmp/test-nodeselector.yml
kubectl get pods -o wide | grep test-nodeselector

