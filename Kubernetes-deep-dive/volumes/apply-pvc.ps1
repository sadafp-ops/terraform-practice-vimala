# Apply PV (static), PVC and Pod
kubectl apply -f pv-demo.yaml
kubectl apply -f pvc-demo.yaml
kubectl apply -f vimala-pod.yaml

# Watch status
kubectl get pv,pvc,pods -o wide
kubectl describe pod pvc-pod
