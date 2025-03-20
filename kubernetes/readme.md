kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f volumes.yaml


kubectl get pods
kubectl get services
kubectl get pv
kubectl get pvc

kubectl delete deployment comfyui
kubectl apply -f deployment.yaml

kubectl rollout status deployment comfyui
