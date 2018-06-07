
function ctrl_c () {
   echo ctrl-c
   kubectl delete pod counter
}

cat <<'EOF' >/tmp/test-logging.yml
apiVersion: v1
kind: Pod
metadata:
  name: counter
spec:
  containers:
  - name: count
    image: busybox
    args: [/bin/sh, -c,
            'i=0; while true; do echo "$i: $(date)"; i=$((i+1)); sleep 1; done']
EOF
kubectl get pod counter >/dev/null 2>&1
if [ $? != 0 ]
then
  trap ctrl_c INT
  kubectl create -f /tmp/test-logging.yml
  echo waiting 10 sec for pod to start && sleep 10
  kubectl logs -f counter
else
  echo There is already a pod with the name "counter" 
fi

