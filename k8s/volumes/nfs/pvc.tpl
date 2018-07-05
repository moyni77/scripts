---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ${techno}-pvc${i}
spec:
  selector:
    matchLabels:
      volumeName.${techno}: ${techno}-pv${i}
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
