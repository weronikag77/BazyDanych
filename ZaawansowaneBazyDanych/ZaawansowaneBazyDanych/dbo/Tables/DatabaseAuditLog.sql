CREATE TABLE [dbo].[DatabaseAuditLog] (
    [LogID]     INT           IDENTITY (1, 1) NOT NULL,
    [EventTime] DATETIME      DEFAULT (getdate()) NULL,
    [LoginName] NVARCHAR (50) DEFAULT (original_login()) NULL,
    [EventXML]  XML           NULL,
    PRIMARY KEY CLUSTERED ([LogID] ASC)
);

