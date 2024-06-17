param location string = resourceGroup().location
param cognitiveServiceName string
param keyVaultName string
param skuName string = 'S0'

resource cognitiveService 'Microsoft.CognitiveServices/accounts@2022-12-01' = {
  name: cognitiveServiceName
  location: location
  kind: 'CognitiveServices'
  sku: {
    name: skuName
  }
  properties: {
    apiProperties: {}
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: 'your-object-id'  // Replace with your AAD object ID
        permissions: {
          keys: [ 'get', 'list', 'set' ]
          secrets: [ 'get', 'list', 'set' ]
        }
      }
    ]
  }
}

resource endpointSecret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = {
  parent: keyVault
  name: '${cognitiveServiceName}-endpoint'
  properties: {
    value: cognitiveService.properties.endpoint
  }
}

resource key1Secret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = {
  parent: keyVault
  name: '${cognitiveServiceName}-key1'
  properties: {
    value: listKeys(cognitiveService.id, '2022-12-01').key1
  }
}

resource key2Secret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = {
  parent: keyVault
  name: '${cognitiveServiceName}-key2'
  properties: {
    value: listKeys(cognitiveService.id, '2022-12-01').key2
  }
}
