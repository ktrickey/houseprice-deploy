kubectl apply -f client/%1/namespace.yml
kubectl config set-context %1
kubectl apply -f client/%1/ingress.yml
kubectl apply -f client/%1/service-web.yml
kubectl apply -f client/%1/web-deployment.yml
kubectl apply -f client/%1/service-backend.yml


kubectl apply -f client/%1/postcode-pvc.yml

kubectl apply -f client/%1/backend-deployment.yml


kubectl apply -f client/%1/mongo-pv.yml
kubectl apply -f client/%1/mongo-pvc.yml
kubectl apply -f client/%1/mongo-deploy.yml


