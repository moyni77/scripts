kubectl apply -f redis-master-deployment.yml
kubectl apply -f redis-master-service.yml
kubectl apply -f redis-slave-deployment.yml
kubectl apply -f redis-slave-service.yml
kubectl apply -f frontend-deployment.yml
kubectl apply -f frontend-service.yml
