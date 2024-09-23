# Define variables
$registryName = "wit2024registry.azurecr.io"
$basePath = "C:\Users\kucsz\Programowanie"
$backendPath = "$basePath\witBackend"
$frontendPath = "$basePath\witFrontend"
$devOpsPath = "$basePath\witDevOps"
$dockerUsername = "rhodgar14"

# Change to the base directory
cd $basePath

# <Delete existing Kubernetes deployments and services>
kubectl delete deployment my-backend-wit2024
kubectl delete service my-backend-wit2024
kubectl delete deployment my-frontend-wit2024
kubectl delete service my-frontend-wit2024
kubectl delete deployment my-db-wit2024
kubectl delete service my-db-wit2024
kubectl delete ingress my-ingress-wit2024

# <Delete existing Docker images>
docker rmi $registryName/my-backend-wit2024:latest
docker rmi my-backend-wit2024:latest
docker rmi $registryName/my-frontend-wit2024:latest
docker rmi my-frontend-wit2024:latest
docker rmi $registryName/my-db-wit2024:latest
docker rmi my-db-wit2024:latest

# <Build and push PostgreSQL image>
docker build -t my-db-wit2024:latest -f "$devOpsPath/postgres/Dockerfile" .
docker tag my-db-wit2024:latest $registryName/my-db-wit2024:latest
docker push $registryName/my-db-wit2024:latest

# <Build and push backend application>
cd $backendPath
mvn clean package -Ptest -DskipTests
cd $basePath
docker build -t my-backend-wit2024:latest -f "$devOpsPath/backend/Dockerfile" .
docker tag my-backend-wit2024:latest $registryName/my-backend-wit2024:latest
docker push $registryName/my-backend-wit2024:latest

# <Build and push frontend application>
cd $frontendPath
ng build --configuration production
cd $basePath
docker build -t my-frontend-wit2024:latest -f "$devOpsPath/frontend/Dockerfile" .
docker tag my-frontend-wit2024:latest $registryName/my-frontend-wit2024:latest
docker push $registryName/my-frontend-wit2024:latest

# <Start Kubernetes cluster and apply configurations>
kubectl apply -f "$devOpsPath/frontend/angular-deployment.yaml"
kubectl apply -f "$devOpsPath/frontend/angular-service.yaml"
kubectl apply -f "$devOpsPath/postgres/postgres-deployment-2.yaml"
kubectl apply -f "$devOpsPath/postgres/postgres-service.yaml"
kubectl apply -f "$devOpsPath/backend/springboot-deployment.yaml"
kubectl apply -f "$devOpsPath/backend/springboot-service.yaml"
kubectl apply -f "$devOpsPath/loadbalancer/backend-loadbalancer.yaml"
kubectl apply -f "$devOpsPath/ingress/ingress.yaml"

# <Create Kubernetes Secret>
kubectl create secret generic db-credentials --from-literal=SPRING_DATASOURCE_USERNAME=postgres --from-literal=SPRING_DATASOURCE_PASSWORD=wit2024 --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic my-dockerhub-secret --from-literal=SPRING_DATASOURCE_USERNAME=postgres --from-literal=SPRING_DATASOURCE_PASSWORD=wit2024 --dry-run=client -o yaml | kubectl apply -f -

# <Check deployments and services>
kubectl get services my-backend-wit2024
kubectl get services my-frontend-wit2024
kubectl get ingress
kubectl get secret db-credentials -o yaml
kubectl get services