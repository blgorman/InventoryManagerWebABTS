CREATE OR ALTER FUNCTION [dbo].[fnItemsWithCsvDetails]()
RETURNS TABLE
AS
RETURN
(
    WITH GenreAgg AS (
        SELECT ig.ItemId,
               STRING_AGG(g.GenreName, ', ') WITHIN GROUP (ORDER BY g.GenreName) AS GenresCsv
        FROM ItemGenres ig
        JOIN Genres g ON g.Id = ig.GenreId
        GROUP BY ig.ItemId
    ),
    ContributorAgg AS (
        SELECT ic.ItemId,
               STRING_AGG(c.ContributorName, ', ') WITHIN GROUP (ORDER BY c.ContributorName) AS ContributorsCsv
        FROM ItemContributors ic
        JOIN Contributors c ON c.Id = ic.ContributorId
        GROUP BY ic.ItemId
    )
    SELECT 
        i.Id AS ItemId,
        i.Name AS ItemName,
        ca.CategoryName AS Category,
        ga.GenresCsv,
        ca2.ContributorsCsv,
        (i.Quantity * i.CurrentValue) AS TotalValue
    FROM Items i
    INNER JOIN Categories ca ON i.CategoryId = ca.Id
    LEFT JOIN GenreAgg ga ON ga.ItemId = i.Id
    LEFT JOIN ContributorAgg ca2 ON ca2.ItemId = i.Id
);
