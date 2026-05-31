CREATE TABLE [SalesLT].[Product] (
    [ProductID]              INT              IDENTITY (1, 1) NOT NULL,
    [Name]                   [dbo].[Name]     NOT NULL,
    [ProductNumber]          NVARCHAR (25)    NOT NULL,
    [Color]                  NVARCHAR (15)    NULL,
    [StandardCost]           MONEY            NOT NULL,
    [ListPrice]              MONEY            NOT NULL,
    [Size]                   NVARCHAR (5)     NULL,
    [Weight]                 DECIMAL (8, 2)   NULL,
    [ProductCategoryID]      INT              NULL,
    [ProductModelID]         INT              NULL,
    [SellStartDate]          DATETIME         NOT NULL,
    [SellEndDate]            DATETIME         NULL,
    [DiscontinuedDate]       DATETIME         NULL,
    [ThumbNailPhoto]         VARBINARY (MAX)  NULL,
    [ThumbnailPhotoFileName] NVARCHAR (50)    NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [DF_Product_rowguid] DEFAULT (newid()) NOT NULL,
    [ModifiedDate]           DATETIME         CONSTRAINT [DF_Product_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Product_ProductID] PRIMARY KEY CLUSTERED ([ProductID] ASC),
    CONSTRAINT [CK_Product_ListPrice] CHECK ([ListPrice]>=(0.00)),
    CONSTRAINT [CK_Product_SellEndDate] CHECK ([SellEndDate]>=[SellStartDate] OR [SellEndDate] IS NULL),
    CONSTRAINT [CK_Product_StandardCost] CHECK ([StandardCost]>=(0.00)),
    CONSTRAINT [CK_Product_Weight] CHECK ([Weight]>(0.00)),
    CONSTRAINT [FK_Product_ProductCategory_ProductCategoryID] FOREIGN KEY ([ProductCategoryID]) REFERENCES [SalesLT].[ProductCategory] ([ProductCategoryID]),
    CONSTRAINT [FK_Product_ProductModel_ProductModelID] FOREIGN KEY ([ProductModelID]) REFERENCES [SalesLT].[ProductModel] ([ProductModelID]),
    CONSTRAINT [AK_Product_Name] UNIQUE NONCLUSTERED ([Name] ASC),
    CONSTRAINT [AK_Product_ProductNumber] UNIQUE NONCLUSTERED ([ProductNumber] ASC),
    CONSTRAINT [AK_Product_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC)
);


GO
create trigger SalesLT.trg_ProductPriceHistory 
on SalesLT.Product
after UPDATE
AS
BEGIN
if update(ListPrice)
    BEGIN
    insert into SalesLT.ProductPriceHistory (ProductID, OldPrice, NewPrice)
    select i.ProductID, d.ListPrice as OldPrice, i.ListPrice as NewPrice
    from inserted i inner join deleted d on i.ProductID = d.ProductID
    where i.ListPrice != d.ListPrice
    END
END;
GO

create trigger SalesLT.trg_CheckPriceIncrease
on SalesLT.Product
instead of update
AS
begin 
set nocount on;
    insert into SalesLT.ProductUpdateLog (ProductID, OldPrice, AttemptedPrice)
    select i.ProductID, d.ListPrice, i.ListPrice
    from inserted i
    join deleted d ON i.ProductID = d.ProductID
    where i.ListPrice > (d.ListPrice * 1.2);

    update p
    set p.ListPrice = i.ListPrice,
        p.ModifiedDate = GETDATE()
    from SalesLT.Product p
    join inserted i ON p.ProductID = i.ProductID
    join deleted d ON i.ProductID = d.ProductID
    where i.ListPrice <= (d.ListPrice * 1.2);
end;