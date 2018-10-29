
kubectl config set-context %1
kubectl delete -f client/%1/ingress.yml
kubectl delete -f client/%1/service-web.yml
kubectl delete -f client/%1/web-deployment.yml
kubectl delete -f client/%1/service-backend.yml

kubectl delete -f client/%1/postcode-pv.yml
kubectl delete -f client/%1/postcode-pvc.yml

kubectl delete -f client/%1/backend-deployment.yml

kubectl delete -f client/%1/mongo-pv.yml
kubectl delete -f client/%1/mongo-pvc.yml
kubectl delete -f client/%1/mongo-deploy.yml
kubectl delete -f client/%1/namespace.yml


