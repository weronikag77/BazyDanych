CREATE TABLE [SalesLT].[ProductUpdateLog] (
    [LogID]          INT      IDENTITY (1, 1) NOT NULL,
    [ProductID]      INT      NULL,
    [OldPrice]       MONEY    NULL,
    [AttemptedPrice] MONEY    NULL,
    [LogDate]        DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([LogID] ASC)
);

