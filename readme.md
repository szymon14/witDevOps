# Inicjalizacja bazy danych

docker build -t my-db-wit2024:latest -f postgres/Dockerfile .

docker tag my-db-wit2024:latest rhodgar14/my-db-wit2024:latest

docker push rhodgar14/my-db-wit2024:latest

docker run --name my-db-wit2024 -p 5432:5432 -d my-db-wit2024:latest

kubectl apply -f ./postgres/postgres-deployment.yaml

kubectl apply -f ./postgres/postgres-service.yaml


# Wystartowanie Frontendu
ng serve

ng build --configuration production

docker build -t my-frontend-wit2024:latest -f docker/Dockerfile .

docker tag my-frontend-wit2024:latest rhodgar14/my-frontend-wit2024:latest

docker push rhodgar14/my-frontend-wit2024:latest

docker run --name my-frontend-wit2024 -p 8081:8081 -d my-frontend-wit2024:latest


kubectl apply -f ./docker/angular-deployment.yaml

kubectl apply -f ./docker/angular-service.yaml

# Backend 

przebudowanie aplikacji

mvn clean package -Ptest

docker build -t my-backend-wit2024:latest -f docker/Dockerfile .

docker tag my-backend-wit2024:latest rhodgar14/my-backend-wit2024:latest

docker push rhodgar14/my-backend-wit2024:latest

docker run --name my-backend-wit2024 -p 8080:8080 -d my-backend-wit2024:latest

kubectl apply -f ./docker/springboot-deployment.yaml

kubectl apply -f ./docker/springboot-service.yaml


Ingress
# Add ingress controller to cluster
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"="/healthz"
