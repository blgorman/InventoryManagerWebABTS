# Listing 12-28: Test

Use this code to complete the test

## The Code

```cs
// Arrange
var itemsToUpdate = new List<Item>
{
    new Item { Id = 1, Name = "Updated1", CategoryId = 1 },
    new Item { Id = 2, Name = "Updated2", CategoryId = 1 }
};

// Act
var result = await _service.UpdateRangeAsync(itemsToUpdate);

// Assert
result.ShouldBe(2);
_mockRepository.Verify(r => r.UpdateRangeAsync(itemsToUpdate), Times.Once);
```  