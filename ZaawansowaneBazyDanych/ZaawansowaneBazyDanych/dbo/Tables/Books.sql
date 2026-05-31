CREATE TABLE [dbo].[Books] (
    [BookID]      INT            IDENTITY (1, 1) NOT NULL,
    [Title]       NVARCHAR (100) NULL,
    [Author]      NVARCHAR (100) NULL,
    [ReleaseYear] BIGINT         NULL,
    [Price]       MONEY          NULL,
    PRIMARY KEY CLUSTERED ([BookID] ASC)
);

