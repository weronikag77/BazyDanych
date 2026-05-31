CREATE TABLE [dbo].[Employees] (
    [EmployeeID] INT           IDENTITY (1, 1) NOT NULL,
    [FirstName]  NVARCHAR (50) NULL,
    [LastName]   NVARCHAR (50) NULL,
    [Department] NVARCHAR (50) NULL,
    [Salary]     MONEY         NULL,
    PRIMARY KEY CLUSTERED ([EmployeeID] ASC)
);

