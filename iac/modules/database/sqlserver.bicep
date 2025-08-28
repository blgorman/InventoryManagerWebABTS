@description('SQL Server name')
param sqlServerName string

@description('SQL Server admin username')
param adminUser string

@description('SQL Server admin password')
@secure()
param adminPassword string

@description('Location for the SQL Server')
param location string = resourceGroup().location

// Generate unique string for SQL Server name
var uniqueSuffix = uniqueString(resourceGroup().id)
var sqlServerNameUnique = '${sqlServerName}-${uniqueSuffix}'

// Create SQL Server
resource sqlServer 'Microsoft.Sql/servers@2024-11-01-preview' = {
  name: sqlServerNameUnique
  location: location
  properties: {
    administratorLogin: adminUser
    administratorLoginPassword: adminPassword
    version: '12.0'
    publicNetworkAccess: 'Enabled'
  }
}

// Create firewall rule to allow Azure services
resource allowAzureServices 'Microsoft.Sql/servers/firewallRules@2024-11-01-preview' = {
  name: 'AllowAzureServices'
  parent: sqlServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

// Output the SQL Server name
output sqlServerName string = sqlServer.name
