@description('SQL Server name')
param sqlServerName string

@description('SQL Server admin username')
param sqlServerAdmin string

@description('SQL Server admin password')
@secure()
param sqlServerPassword string

@description('SQL Database name')
param sqlDbName string

@description('Web App name')
param webAppName string

// Get reference to existing Web App
resource existingWebApp 'Microsoft.Web/sites@2024-11-01' existing = {
  name: webAppName
}

// Get reference to existing staging slot
resource existingStagingSlot 'Microsoft.Web/sites/slots@2024-11-01' existing = {
  name: 'staging'
  parent: existingWebApp
}

// Compose the connection string using environment function
var connectionString = 'Server=tcp:${sqlServerName}.${environment().suffixes.sqlServerHostname},1433;Initial Catalog=${sqlDbName};User ID=${sqlServerAdmin};Password=${sqlServerPassword};Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;'

// Configure App Service application settings for production
resource productionAppSettings 'Microsoft.Web/sites/config@2024-11-01' = {
  name: 'appsettings'
  parent: existingWebApp
  properties: {
    ConnectionStrings__InventoryManagerIdentityDB: connectionString
    ConnectionStrings__InventoryDbConnection: connectionString
    ASPNETCORE_ENVIRONMENT: 'Production'
  }
}

// Configure App Service application settings for staging
resource stagingAppSettings 'Microsoft.Web/sites/slots/config@2024-11-01' = {
  name: 'appsettings'
  parent: existingStagingSlot
  properties: {
    ConnectionStrings__InventoryManagerIdentityDB: connectionString
    ConnectionStrings__InventoryDbConnection: connectionString
    ASPNETCORE_ENVIRONMENT: 'Staging'
  }
}

// Outputs
output productionConnectionString string = connectionString
output stagingConnectionString string = connectionString
