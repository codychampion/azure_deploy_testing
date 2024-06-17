#!/bin/bash

# Variables
resourceGroupName="yourResourceGroupName"
location="yourLocation"
cognitiveServiceName="yourCognitiveServiceName"
keyVaultName="yourKeyVaultName"

# Create resource group
az group create --name $resourceGroupName --location $location

# Deploy the Bicep script
az deployment group create \
  --resource-group $resourceGroupName \
  --template-file azure-ai-keyvault-deployment.bicep \
  --parameters cognitiveServiceName=$cognitiveServiceName keyVaultName=$keyVaultName

echo "Deployment completed."
