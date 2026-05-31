CREATE TABLE [SalesLT].[ProductInventory] (
    [ProductID]         INT NOT NULL,
    [InventoryQuantity] INT NULL,
    PRIMARY KEY CLUSTERED ([ProductID] ASC),
    FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID])
);

