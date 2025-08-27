# Listing 12-3: Create the data stubs

The system will need to be able to return data for Items, Categories, Genres, Contributors, and the join for Items to those tables.

## The Code

Create List<T> object variables for each of the major tables (Item, Genre, Category, Contributor, ItemContributor). Replace the line `//TODO: add Lists here` with the following:

```cs
private List<Item> _items;
private List<Genre> _genres;
private List<Category> _categories;
private List<Contributor> _contributors;
private List<ItemContributor> _itemContributors;
```  
