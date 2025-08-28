@description('App Service name')
param appName string = 'inventorymanagerweb'

@description('App Service Plan resource ID')
param appServicePlanId string

@description('Location for the App Service')
param location string = resourceGroup().location

// Generate unique string for App Service name
var uniqueSuffix = uniqueString(resourceGroup().id)
var appServiceNameUnique = '${appName}-${uniqueSuffix}'

// Create App Service
resource appService 'Microsoft.Web/sites@2024-11-01' = {
  name: appServiceNameUnique
  location: location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOCKER|nginx:latest' // Placeholder container image
      alwaysOn: true
      ftpsState: 'Disabled'
      httpLoggingEnabled: true
      logsDirectorySizeLimit: 35
      detailedErrorLoggingEnabled: true
      requestTracingEnabled: true
      remoteDebuggingEnabled: false
    }
  }
}

// Create staging deployment slot
resource stagingSlot 'Microsoft.Web/sites/slots@2024-11-01' = {
  name: 'staging'
  parent: appService
  location: location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOCKER|nginx:latest' // Placeholder container image
      alwaysOn: true
      ftpsState: 'Disabled'
      httpLoggingEnabled: true
      logsDirectorySizeLimit: 35
      detailedErrorLoggingEnabled: true
      requestTracingEnabled: true
      remoteDebuggingEnabled: false
    }
  }
}

// Outputs
output webAppName string = appService.name
output webAppUrl string = 'https://${appService.properties.defaultHostName}'
output stagingSlotName string = stagingSlot.name
