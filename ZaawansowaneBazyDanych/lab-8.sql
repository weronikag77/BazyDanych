-- =============================================
-- Weronika
-- Gurba
-- 233082
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================
create table SalesLT.ProductPriceHistory (
    AuditID int identity primary key,
    ProductID int not null,
    OldPrice money not null,
    NewPrice money not null
);
GO

create trigger SalesLT.trg_ProductPriceHistory 
on SalesLT.Product
after UPDATE
AS
BEGIN
if update(ListPrice)
    BEGIN
    insert into SalesLT.ProductPriceHistory (ProductID, OldPrice, NewPrice)
    select i.ProductID, d.ListPrice as OldPrice, i.ListPrice as NewPrice
    from inserted i inner join deleted d on i.ProductID = d.ProductID
    where i.ListPrice != d.ListPrice
    END
END;
go


-- =============================================
-- Zadanie 2
-- =============================================
create table SalesLT.DeletedCustomersLog (
    LogID int identity primary key,
    CustomerID int not null,
    FirstName nvarchar(50),
    LastName nvarchar(50), 
)
GO

alter table [233082].Customer
set (System_Versioning = off)
go

create trigger [233082].trg_Customer_InsteadOfDelete
on [233082].Customer
instead of DELETE
AS
BEGIN
set nocount on;
    insert into SalesLT.DeletedCustomersLog (CustomerID, FirstName, LastName)
    select *
    from deleted d 
    where exists (
        select * from SalesLT.SalesOrderHeader soh
        where soh.CustomerID = d.CustomerID
    );

    delete from [233082].Customer
    where CustomerID in (
        select d.CustomerID from deleted d
        where not exists (
            select * from SalesLT.SalesOrderHeader soh 
            where soh.CustomerID = d.CustomerID
        )
    );
END;
go

-- =============================================
-- Zadanie 3
-- =============================================
with CategoryHierarchy AS
(
    select ProductCategoryID, ParentProductCategoryID, Name, cast(Name as nvarchar(max)) as Path
    from SalesLT.ProductCategory
    where ParentProductCategoryID is null

    union all

    select pc.ProductCategoryID, pc.ParentProductCategoryID, pc.Name, ch.Path + ' -> ' + cast(pc.Name as nvarchar(max))
    from SalesLT.ProductCategory pc 
    join CategoryHierarchy ch on pc.ParentProductCategoryID = ch.ProductCategoryID

)

select ProductCategoryID, Path
from CategoryHierarchy
order by Path;

-- =============================================
-- Zadanie 4
-- =============================================
create table SalesLT.ProductUpdateLog (
    LogID int identity primary key,
    ProductID int,
    OldPrice money,
    AttemptedPrice money,
    LogDate DATETIME DEFAULT GETDATE()
);
go

create trigger SalesLT.trg_CheckPriceIncrease
on SalesLT.Product
instead of update
AS
begin 
set nocount on;
    insert into SalesLT.ProductUpdateLog (ProductID, OldPrice, AttemptedPrice)
    select i.ProductID, d.ListPrice, i.ListPrice
    from inserted i
    join deleted d ON i.ProductID = d.ProductID
    where i.ListPrice > (d.ListPrice * 1.2);

    update p
    set p.ListPrice = i.ListPrice,
        p.ModifiedDate = GETDATE()
    from SalesLT.Product p
    join inserted i ON p.ProductID = i.ProductID
    join deleted d ON i.ProductID = d.ProductID
    where i.ListPrice <= (d.ListPrice * 1.2);
end;
go

update SalesLT.Product
set ListPrice = 77.00
where ProductID = 707 -- przykład pokazujący, ze trigger z powodzeniem przerywa operację

-- =============================================
-- Zadanie 5
-- =============================================
create table dbo.DatabaseAuditLog (
    LogID int identity primary key,
    EventTime datetime default getdate(),
    LoginName nvarchar(50) default original_login(),
    EventXML xml
);
GO

create trigger trg_DatabaseChangesAudit
on database
for create_table, alter_table, drop_table
as
begin
    set nocount on;
    insert into dbo.DatabaseAuditLog (EventXML)
    values (EVENTDATA());
end;
go


-- =============================================
-- Zadanie 6
-- =============================================

-- Utworzona rekurencja pozwala przedstawić strukturę organizacyjną zespołu sprzedaży. Relacja rodzic-dziecko występuje między
-- ParentPositionID a EmployeeID. ReportingPath pozwala na wizualizację hierarchii w dziale.

create table SalesLT.SalesTeam (
    EmployeeID int primary key,
    FirstName nvarchar(50) not null,
    LastName NVARCHAR(50) not null,
    Position nvarchar(50),
    ParentPositionID int null
    constraint fk_SalesTeamManager foreign key (ParentPositionID)
    references SalesLT.SalesTeam(EmployeeID)
);
GO


insert into SalesLT.SalesTeam(EmployeeID, FirstName, LastName, Position, ParentPositionID)
values 
    (1, 'Victoria', 'Wallace', 'CEO', null),
    (2, 'Mateo', 'Bradford', 'Sales Manager', 1),
    (3, 'Dakota', 'Maxwell', 'Marketing Manager', 1),
    (4, 'Hugh', 'Hudson', 'Senior Sales', 2),
    (5, 'Larry', 'Corona', 'Junior Sales', 4);
go

with SalesEmployeesHierarchy as(
    select EmployeeID, FirstName, LastName, Position, CAST(LastName as nvarchar(max)) as ReportingPath
    from SalesLT.SalesTeam
    where ParentPositionID is null

    union all

    select st.EmployeeID, st.FirstName, st.LastName, st.Position, 
    seh.ReportingPath + ' -> ' + cast(st.LastName as nvarchar(max))
    from SalesLT.SalesTeam st inner join SalesEmployeesHierarchy seh 
    on st.ParentPositionID = seh.EmployeeID
)

select FirstName + ' ' + LastName as Pracownik, Position, ReportingPath
from SalesEmployeesHierarchy
order by ReportingPath