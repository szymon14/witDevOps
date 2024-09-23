# Define variables
$registryName = "wit2024registry.azurecr.io"
$resourceGroup = "wit2024"
$clusterName = "witCluster"

# Make the wit cluster the current context
az aks get-credentials --resource-group $resourceGroup --name $clusterName

# Check if the cluster is running
$clusterStatus = az aks show --resource-group $resourceGroup --name $clusterName --query "powerState.code" -o tsv

if ($clusterStatus -eq "Running") {
    Write-Output "The cluster is currently running. Stopping and deleting resources..."

    # Delete existing Kubernetes deployments, services, and ingress
    kubectl delete deployment my-backend-wit2024 --ignore-not-found
    kubectl delete service my-backend-wit2024 --ignore-not-found
    kubectl delete deployment my-frontend-wit2024 --ignore-not-found
    kubectl delete service my-frontend-wit2024 --ignore-not-found
    kubectl delete deployment my-db-wit2024 --ignore-not-found
    kubectl delete service my-db-wit2024 --ignore-not-found
    kubectl delete ingress my-ingress-wit2024 --ignore-not-found

    # Log in to Azure Container Registry
    az acr login --name $registryName

    # Delete existing Docker images
    docker rmi $registryName/my-backend-wit2024:latest --force
    docker rmi my-backend-wit2024:latest --force
    docker rmi $registryName/my-frontend-wit2024:latest --force
    docker rmi my-frontend-wit2024:latest --force
    docker rmi $registryName/my-db-wit2024:latest --force
    docker rmi my-db-wit2024:latest --force

    Write-Output "All resources, images, and services have been deleted."

    # Optionally, you can stop the cluster if desired
    # Stopping AKS clusters is not directly supported, you typically manage node scaling or deallocation of resources instead
} else {
    Write-Output "The cluster is not running."
}

# Check the status of deployments, services, and ingress
kubectl get services my-backend-wit2024 --ignore-not-found
kubectl get services my-frontend-wit2024 --ignore-not-found
kubectl get ingress my-ingress-wit2024 --ignore-not-found
kubectl get secret db-credentials -o yaml --ignore-not-found
kubectl get services
