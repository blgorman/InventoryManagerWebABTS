# Listing 12-31: The Initialize Async method from the Test Fixture

The Initialize method makes sure the database is set up and the migrations are applied.

## The Code  

```cs
public async Task InitializeAsync()
{
    //Start SQL Server in Docker
    await _container.StartAsync();

    ConnectionString = _container.GetConnectionString();  
    var options = new DbContextOptionsBuilder<InventoryDbContext>()
        .UseSqlServer(ConnectionString)
        .EnableSensitiveDataLogging()
        .Options;

    Db = new InventoryDbContext(options);

    // 3) Create schema (or run migrations)
    // If you have migrations, prefer Migrate(); otherwise EnsureCreated();
    await Db.Database.MigrateAsync();

    _connection = Db.Database.GetDbConnection();
    await _connection.OpenAsync();
}
```  