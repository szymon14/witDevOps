# Define variables
$registryName = "wit2024registry.azurecr.io"
$basePath = "C:\Users\kucsz\Programowanie"
$backendPath = "$basePath\witBackend"
$frontendPath = "$basePath\witFrontend"
$devOpsPath = "$basePath\witDevOps"
$namespace = "aks-store"

# Start from main
cd $basePath

# Make wit cluster current context
az aks get-credentials --resource-group wit2024 --name witCluster

# Log in to Azure Container Registry
az acr login --name wit2024Registry

# Create namespace if it doesn't exist
kubectl create namespace $namespace

# <Delete existing Kubernetes deployments and services>
kubectl delete deployment my-backend-wit2024 -n $namespace
kubectl delete service my-backend-wit2024 -n $namespace
kubectl delete deployment my-frontend-wit2024 -n $namespace
kubectl delete service my-frontend-wit2024 -n $namespace
kubectl delete deployment my-db-wit2024 -n $namespace
kubectl delete service my-db-wit2024 -n $namespace
kubectl delete ingress my-ingress-wit2024 -n $namespace

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
mvn clean package -Ptest # Remove -DskipTests if you want to run tests
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

# <Create Kubernetes Secret>
kubectl create secret generic db-credentials --from-literal=SPRING_DATASOURCE_USERNAME=postgres --from-literal=SPRING_DATASOURCE_PASSWORD=wit2024 --dry-run=client -o yaml | kubectl apply -f - -n $namespace

# <Deploy Kubernetes resources>
kubectl apply -f "$devOpsPath/postgres/postgres-deployment-2.yaml" -n $namespace
kubectl apply -f "$devOpsPath/postgres/postgres-service.yaml" -n $namespace
kubectl apply -f "$devOpsPath/frontend/angular-deployment.yaml" -n $namespace
kubectl apply -f "$devOpsPath/frontend/angular-service.yaml" -n $namespace
kubectl apply -f "$devOpsPath/backend/springboot-deployment.yaml" -n $namespace
kubectl apply -f "$devOpsPath/backend/springboot-service.yaml" -n $namespace
kubectl apply -f "$devOpsPath/ingress/ingress.yaml" -n $namespace

# <Check deployments and services>
kubectl get services -n $namespace
kubectl get ingress -n $namespace
kubectl get secret db-credentials -n $namespace -o yaml

kubectl rollout restart deployment my-backend-wit2024 -n aks-store
