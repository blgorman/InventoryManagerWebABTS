﻿using EF10_InventoryModels;
using EF10_InventoryModels.DTOs;
using System.Linq.Expressions;

namespace EF10_InventoryDataLayer;

public interface IItemRepository : IGenericRepository<Item>
{
    Task<Item?> GetItemByNameWithCategoryAsync(string name);
    Task<Item?> GetItemByNameWithGenreAsync(string name);
    Task<Item?> GetItemByNameWithGenreByNameAsync(string itemName, string genreName);
    Task<List<Item>> GetItemsByFilterAsync(string filter); //THIS Is overkill but was a previous example so kept it
    Task<List<Item>> GetAllItemsWithCategoryAsync();
    Task<int> UpdateRangeAsync(List<Item> items); // Custom method to update range of items
    Task<bool> BulkLoadItemDataAsync(List<ParsedItemDataDTO> parsedItems);
    //added for web solution
    Task<List<ItemWithCsvDetailsDTO>> GetFullItemDetails();
    Task<Item?> UpdateItemWithRelationshipsAsync(Item item);
}
