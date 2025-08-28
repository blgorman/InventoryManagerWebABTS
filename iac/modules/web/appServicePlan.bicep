@description('App Service Plan name')
param appServicePlanName string

@description('App Service Plan SKU')
param sku string = 'P0V3'

@description('Location for the App Service Plan')
param location string = resourceGroup().location

// Create App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  properties: {
    reserved: true // Required for Linux plans
  }
  sku: {
    name: sku
  }
}

// Output the App Service Plan ID
output appServicePlanId string = appServicePlan.id
output appServicePlanName string = appServicePlan.name
