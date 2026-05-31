CREATE TABLE [SalesLT].[SalesTeam] (
    [EmployeeID]       INT           NOT NULL,
    [FirstName]        NVARCHAR (50) NOT NULL,
    [LastName]         NVARCHAR (50) NOT NULL,
    [Position]         NVARCHAR (50) NULL,
    [ParentPositionID] INT           NULL,
    PRIMARY KEY CLUSTERED ([EmployeeID] ASC),
    CONSTRAINT [fk_SalesTeamManager] FOREIGN KEY ([ParentPositionID]) REFERENCES [SalesLT].[SalesTeam] ([EmployeeID])
);

