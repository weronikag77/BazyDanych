CREATE TABLE [dbo].[MovieRentals] (
    [RentalID]   INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID] INT           NULL,
    [Genre]      NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([RentalID] ASC)
);

