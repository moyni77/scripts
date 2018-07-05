---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ${techno}-pv${i}
  labels:
    volumeName.${techno}: ${techno}-pv${i}

spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  nfs:
    path: /shares/pv${i}
    server: clh-nfs.cloudra.local
#  persistentVolumeReclaimPolicy: Recycle

