# <Delete if something exists>
kubectl delete deployment my-backend-wit2024
kubectl delete service my-backend-wit2024
kubectl delete deployment my-frontend-wit2024
kubectl delete service my-frontend-wit2024
kubectl delete deployment my-db-wit2024
kubectl delete service my-db-wit2024
kubectl delete ingress my-ingress-wit2024

# <Delete existing images>
docker rmi rhodgar14/my-backend-wit2024:latest
docker rmi my-backend-wit2024:latest
docker rmi rhodgar14/my-frontend-wit2024:latest
docker rmi my-frontend-wit2024:latest
docker rmi rhodgar14/my-db-wit2024:latest
docker rmi my-db-wit2024:latest

# <Build postgres image, tag and push>
docker build -t my-db-wit2024:latest -f postgres/Dockerfile .
docker tag my-db-wit2024:latest rhodgar14/my-db-wit2024:latest
docker push rhodgar14/my-db-wit2024:latest

# <Build app with maven, then build image, tag and push>
cd ../SzymonKucBackend/
mvn clean package -Ptest -DskipTests
docker build -t my-backend-wit2024:latest -f docker/Dockerfile .
docker tag my-backend-wit2024:latest rhodgar14/my-backend-wit2024:latest
docker push rhodgar14/my-backend-wit2024:latest

# <Build app with ng, then build image, tag and push>
cd ../SzymonKucFrontend/
ng build --configuration production
cd ../SzymonKucDevOps
docker build -t my-frontend-wit2024:latest -f frontend/Dockerfile .
docker tag my-frontend-wit2024:latest rhodgar14/my-frontend-wit2024:latest
docker push rhodgar14/my-frontend-wit2024:latest

# <Start kubernetes cluster>
cd ../SzymonKucDevOps
kubectl apply -f ./docker/angular-deployment.yaml
kubectl apply -f ./docker/angular-service.yaml
kubectl apply -f ./postgres/postgres-deployment-2.yaml
kubectl apply -f ./postgres/postgres-service.yaml
kubectl apply -f ./docker/springboot-deployment.yaml
kubectl apply -f ./docker/springboot-service.yaml
# <Apply Ingress Configuration>
kubectl apply -f ./ingress/ingress.yaml
# <Create Kubernetes Secreet>
kubectl create secret generic db-credentials --from-literal=SPRING_DATASOURCE_USERNAME=postgres --from-literal=SPRING_DATASOURCE_PASSWORD=wit2024
# <If we want 2 pods of frontend and backend we need Load-Balancer>
kubectl apply -f ./loadbalancer/backend-loadbalancer.yaml


# <Get backend and frontend IPs and verify secret>
kubectl get services my-backend-wit2024
kubectl get services my-frontend-wit2024
kubectl get ingress
kubectl get secret db-credentials -o yaml
kubectl get services