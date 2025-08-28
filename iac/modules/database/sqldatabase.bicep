@description('Database SKU')
param databaseSku string = 'basic'

@description('SQL Server name (from SQL Server module output)')
param sqlServerName string

@description('SQL Database name')
param sqlDbName string

@description('Location for the SQL Database')
param location string = resourceGroup().location

// Get reference to existing SQL Server
resource existingSqlServer 'Microsoft.Sql/servers@2023-05-01-preview' existing = {
  name: sqlServerName
}

// SKU mapping for database service objectives
var skuMapping = {
  basic: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 5
  }
  standard: {
    name: 'Standard'
    tier: 'Standard' 
    capacity: 10
  }
  premium: {
    name: 'Premium'
    tier: 'Premium'
    capacity: 125
  }
}

// Create SQL Database
resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  name: sqlDbName
  parent: existingSqlServer
  location: location
  sku: skuMapping[databaseSku]
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648 // 2GB
  }
}

// Output the database name
output sqlDatabaseName string = sqlDatabase.name