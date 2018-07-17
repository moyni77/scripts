kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nfs-provisioner
EOF
