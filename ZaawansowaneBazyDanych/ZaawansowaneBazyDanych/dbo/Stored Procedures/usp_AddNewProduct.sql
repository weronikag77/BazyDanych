create   procedure dbo.usp_AddNewProduct
    @ProductName nvarchar(50),
    @ProductCategory nvarchar(100),
    @ProductNumber nvarchar(25),
    @ListPrice money,
    @InventoryQuantity INT
AS
BEGIN
    set nocount on;
    set XACT_ABORT on;

    if @ListPrice <= 0
    BEGIN
        raiserror(N'Błąd: Cena produktu musi być większa od zera.', 16, 1)
    end
    else if @InventoryQuantity < 0
    BEGIN
        raiserror(N'Błąd: Ilość sztuk w magazynie nie może być ujemna.', 16, 1)
    end
    ELSE
        begin TRY
        begin tran;
            declare @CategoryID int
            select @CategoryID = ProductCategoryID from SalesLT.ProductCategory
            where [Name] = @ProductCategory;

            INSERT INTO SalesLT.Product (
            [Name],            
            [ProductCategoryID], 
            [ProductNumber], 
            [ListPrice], 
            [StandardCost], 
            [SellStartDate], 
            [rowguid], 
            [ModifiedDate]
        )
            values (@ProductName, @CategoryID, @ProductNumber, @ListPrice, @ListPrice, getdate(), newid(), getdate())

            declare @ProductID int
            set @ProductID = @@Identity

            insert into SalesLT.ProductInventory (ProductID, InventoryQuantity)
            values (@ProductID, @InventoryQuantity)
        commit tran;
        return 0; 
    end TRY
    begin CATCH
        if @@TRANCOUNT > 0 rollback;
        return -99;
    end CATCH
end;