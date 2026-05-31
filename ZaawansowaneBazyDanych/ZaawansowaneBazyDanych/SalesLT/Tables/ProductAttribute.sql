CREATE TABLE [SalesLT].[ProductAttribute] (
    [ProductID]  INT                                             NOT NULL,
    [Attributes] XML(CONTENT [SalesLT].[ProductAttributeSchema]) NOT NULL,
    PRIMARY KEY CLUSTERED ([ProductID] ASC),
    CONSTRAINT [FK_ProductAttribute_Product] FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID])
);

