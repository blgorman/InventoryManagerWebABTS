# Listing 12-33: The RepoTestBase Dispose Async method

This dispose method will roll back any transaction that was in process and also clear the ChangeTracker.

This operation is incredibly important because now you can use the transaction to prevent the underlying data changes for things like adding or removing from persisting across test runs.

The reset of the ChangeTracker ensures that the context is back to the default state with no modifications at the start of every test run.

## The Code

```cs
// the code for InitializeAsync (shown in Listing 12-32)

public async Task DisposeAsync()
{
    // Nuke all changes from the test
    if (_tx is not null)
    {
        await _tx.RollbackAsync();
        await _tx.DisposeAsync();
    }
    _itf.Db.ChangeTracker.Clear();
}
```  