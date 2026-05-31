create   function Student_2.ufn_ProductsJsonByCategory(
    @CategoryName nvarchar(50)
)
returns nvarchar(max)
AS
BEGIN   
    declare @Product nvarchar(max)

    set @Product = (
    select pc.Name as Category, p.Name as ProductName, p.ListPrice
    from SalesLT.ProductCategory pc join SalesLT.Product p 
    on pc.ProductCategoryID = p.ProductCategoryID
    where pc.Name = @CategoryName
    for json path);
    return @Product
end;