CREATE TABLE [dbo].[BookStatistics] (
    [BookID]      INT            IDENTITY (1, 1) NOT NULL,
    [Title]       NVARCHAR (100) NULL,
    [Author]      NVARCHAR (50)  NULL,
    [Genre]       NVARCHAR (50)  NULL,
    [RentalCount] INT            NULL,
    PRIMARY KEY CLUSTERED ([BookID] ASC)
);

