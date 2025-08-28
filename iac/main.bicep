targetScope = 'subscription'

@description('Name of the resource group to create')
param resourceGroupName string = 'rg-inventorymgrweb'

@description('Location for all resources')
param location string = 'centralus'

@description('SQL Server name')
param sqlServerName string

@description('SQL Server admin username')
param adminUser string = 'sqladmin'

@description('SQL Server admin password')
@secure()
param adminPassword string

@description('SQL Database name')
param sqlDbName string = 'invmgrdb'

@description('SQL Database SKU')
param databaseSku string = 'basic'

@description('App Service Plan name')
param appServicePlanName string

@description('App Service Plan SKU')
param sku string = 'P0V3'

@description('App Service name')
param appName string = 'inventorymanagerweb'

// Create resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

// Deploy SQL Server module
module sqlServer 'modules/database/sqlserver.bicep' = {
  name: 'sqlServerDeployment'
  scope: resourceGroup
  params: {
    sqlServerName: sqlServerName
    adminUser: adminUser
    adminPassword: adminPassword
    location: location
  }
}

// Deploy SQL Database module
module sqlDatabase 'modules/database/sqldatabase.bicep' = {
  name: 'sqlDatabaseDeployment'
  scope: resourceGroup
  params: {
    databaseSku: databaseSku
    sqlServerName: sqlServer.outputs.sqlServerName
    sqlDbName: sqlDbName
    location: location
  }
}

// Deploy App Service Plan module
module appServicePlan 'modules/web/appServicePlan.bicep' = {
  name: 'appServicePlanDeployment'
  scope: resourceGroup
  params: {
    appServicePlanName: appServicePlanName
    sku: sku
    location: location
  }
}

// Deploy App Service module
module appService 'modules/web/appService.bicep' = {
  name: 'appServiceDeployment'
  scope: resourceGroup
  params: {
    appName: appName
    appServicePlanId: appServicePlan.outputs.appServicePlanId
    location: location
  }
}

// Deploy App Service Configuration module
module appServiceConfig 'modules/web/appServiceConfig.bicep' = {
  name: 'appServiceConfigDeployment'
  scope: resourceGroup
  params: {
    sqlServerName: sqlServer.outputs.sqlServerName
    sqlServerAdmin: adminUser
    sqlServerPassword: adminPassword
    sqlDbName: sqlDbName
    webAppName: appService.outputs.webAppName
  }
}

// Outputs
output resourceGroupName string = resourceGroup.name
output sqlServerName string = sqlServer.outputs.sqlServerName
output webAppName string = appService.outputs.webAppName
output webAppUrl string = appService.outputs.webAppUrl