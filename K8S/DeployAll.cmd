kubectl apply -f client/%1/namespace.yml
kubectl config set-context %1
kubectl apply -f client/%1/ingress.yml
kubectl apply -f client/%1/service-web.yml
kubectl apply -f client/%1/web-deployment.yml
kubectl apply -f client/%1/service-backend.yml
kubectl apply -f client/%1/backend-deployment.yml
