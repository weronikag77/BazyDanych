create function Student_2.ufn_ProductPriceStatus(
    @ProductsJson nvarchar(max)
)
returns TABLE
as
return
(
    select ProductID, Name, ListPrice, 
    Student_2.ufn_IsPriceHigherThanCurrent('{"ProductID":' + cast(ProductID as varchar) + ', "ListPrice":' 
    + cast(ListPrice as varchar) + '}') as IsHigherThanInDB
    from openjson(@ProductsJson)

    with (
        ProductID int,
        Name nvarchar(max),
        ListPrice money
    )
);