---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ${techno}-pv${i}
  labels:
    volumeName.${techno}: ${techno}-pv${i}
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  flexVolume:
    driver: hpe.com/hpe
    options:
      name: ${techno}-pv${i}
      size: "2"

