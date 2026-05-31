CREATE TABLE [233082].[MSSQL_TemporalHistoryFor_1893581784] (
    [CustomerID]   INT                   NOT NULL,
    [NameStyle]    [dbo].[NameStyle]     NOT NULL,
    [Title]        NVARCHAR (8)          NULL,
    [FirstName]    [dbo].[Name]          NOT NULL,
    [MiddleName]   [dbo].[Name]          NULL,
    [LastName]     [233082].[W2_surname] NOT NULL,
    [Suffix]       NVARCHAR (10)         NULL,
    [CompanyName]  NVARCHAR (128)        NULL,
    [SalesPerson]  NVARCHAR (256)        NULL,
    [EmailAddress] NVARCHAR (50)         NULL,
    [Phone]        [dbo].[Phone]         NULL,
    [PasswordHash] VARCHAR (128)         NOT NULL,
    [PasswordSalt] VARCHAR (10)          NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER      NOT NULL,
    [ModifiedDate] DATETIME              NOT NULL,
    [SysStartTime] DATETIME2 (7)         NOT NULL,
    [SysEndTime]   DATETIME2 (7)         NOT NULL
);


GO
CREATE CLUSTERED INDEX [ix_MSSQL_TemporalHistoryFor_1893581784]
    ON [233082].[MSSQL_TemporalHistoryFor_1893581784]([SysEndTime] ASC, [SysStartTime] ASC) WITH (DATA_COMPRESSION = PAGE);

