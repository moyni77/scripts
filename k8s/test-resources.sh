cat <<EOF >/tmp/test-resources.yml
apiVersion: v1
kind: Pod
metadata:
  name: test-resources
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
    resources:
      requests:
         memory: "64Mi"
         cpu: "500m"
#         ephemeral-storage: "20Gi"
      limits:
         memory: "128Mi"
         cpu: "750m"
#        ephemeral-storage: "40Gi"
  nodeSelector:
    worker: "yes"
EOF

kubectl label nodes --overwrite=true clh-worker01.cloudra.local worker=yes
kubectl create -f /tmp/test-resources.yml
kubectl get pods -o wide | grep test-resources

