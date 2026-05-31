CREATE TABLE [SalesLT].[ProductPriceHistory] (
    [AuditID]   INT   IDENTITY (1, 1) NOT NULL,
    [ProductID] INT   NOT NULL,
    [OldPrice]  MONEY NOT NULL,
    [NewPrice]  MONEY NOT NULL,
    PRIMARY KEY CLUSTERED ([AuditID] ASC)
);

