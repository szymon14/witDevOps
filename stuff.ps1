# Add ingress controller to cluster
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"="/healthz"

#Scale resource usage
helm upgrade nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --set controller.resources.requests.memory=50Mi --set controller.resources.requests.cpu=50m

#Increase node count
az aks scale --resource-group wit2024 --name witCluster --node-count 2

# Required by azure
helm upgrade nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"="/healthz"
