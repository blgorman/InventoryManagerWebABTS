# Listing 12-47: Testing the code with a unit of work

Use this code to implement the final test that rollsback any changes if the transaction fails.

## The Code  

```cs
var repo = new ItemRepository(_itf.Db);
var beforeItems = await repo.GetAllAsync();
var itemCount = beforeItems.Count();
var item1 = new Item() { Name = "Bulk Item 1", CategoryId = 1
        , Description = "Bulk Item 1 Description"
        , IsActive = true, Genres = new List<Genre>() };
var item2 = new Item() { Name = "Bulk Item 2", CategoryId = 2
        , Description = "Bulk Item 2 Description", IsActive = true
        , Genres = new List<Genre>() };

var contributorDetails1 = new Dictionary<int, string>();
contributorDetails1.Add(1, "Actor");

var contributorDetails2 = new Dictionary<int, string>();
contributorDetails2.Add(1, "Musician");

//item 1 should add
//item 2 should fail due to invalid genre ids, so nothing should be added
var items = new List<ParsedItemDataDTO>
{
    new ParsedItemDataDTO { Item = item1, ContributorData = contributorDetails1
                            , GenreIds = new List<int>() {1, 2, 3 } },
    new ParsedItemDataDTO { Item = item2, ContributorData = contributorDetails2
                            , GenreIds = new List<int>() {75, 99, 131 } }
};

var success = await repo.BulkLoadItemDataAsync(items);
success.ShouldBeFalse(); // Should fail due to invalid genre ids, and rollback
var afterItems = await repo.GetAllAsync();
afterItems.Count().ShouldBe(itemCount); // No new items should be added
```  