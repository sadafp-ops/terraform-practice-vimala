Build & deploy instructions for the pe-webhook image

1) Build and push to Docker Hub (recommended)

# from the webhook directory
docker build -t <dockerhub-username>/pe-webhook:latest .
docker login
docker push <dockerhub-username>/pe-webhook:latest

# edit webhook-deployment.yaml: set image: <dockerhub-username>/pe-webhook:latest
kubectl apply -f webhook-deployment.yaml

2) Build and load into kind (local cluster)

# build locally
docker build -t pe-webhook:latest .
# load into kind (replace <cluster-name>)
kind load docker-image pe-webhook:latest --name <cluster-name>
# ensure imagePullPolicy: IfNotPresent in the Deployment, then:
kubectl apply -f webhook-deployment.yaml

3) Build and load into minikube

# build with minikube's docker daemon
minikube image build -t pe-webhook:latest -f Dockerfile .
# or build locally and run:
minikube image load pe-webhook:latest
kubectl apply -f webhook-deployment.yaml

4) Create the TLS secret (after generating tls.crt/tls.key)

kubectl create secret tls pe-webhook-tls --cert=tls.crt --key=tls.key -n platform-demo

5) Apply manifests and test

kubectl apply -f webhook-deployment.yaml
kubectl apply -f validating.yaml
kubectl get pods -n platform-demo
kubectl logs -l app=pe-webhook -n platform-demo --tail=200

Notes:
- On Windows, use Git Bash or WSL for the `openssl` commands, or follow PowerShell steps with `New-SelfSignedCertificate`.
- If you use a private registry, create an `imagePullSecret` and reference it from the Deployment.