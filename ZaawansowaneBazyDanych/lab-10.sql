-- =============================================
-- Weronika
-- Gurba
-- 233082
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================
create or alter procedure dbo.usp_AddCustomer
    @FirstName [dbo].[Name],
    @LastName [233082].[W2_surname],
    @EmailAddress nvarchar(50) = null,
    @Phone [dbo].[Phone] = null
AS
BEGIN
    insert into [233082].Customer (FirstName, LastName, EmailAddress, Phone, PasswordHash, PasswordSalt, rowguid, ModifiedDate)
    values (@FirstName, @LastName, @EmailAddress, @Phone, 'KPdtRdvqeAhj6wyxEsFdshBDNXxkCXn+CRgbvJItknw=', 
    '1UjXYs4=', 'e532f657-a9af-4a7d-a645-c429d6e02491', getdate());
end;
go

exec dbo.usp_AddCustomer 'Anna', 'Culhane', 'annac@gmail.com', '746928098'
go

-- =============================================
-- Zadanie 2
-- =============================================
create or alter procedure dbo.usp_GetCustomerData
    @CustomerID int = null,
    @FirstName [dbo].[Name] = null,
    @LastName [233082].[W2_surname] = null,
    @EmailAddress nvarchar(50) = null
AS
BEGIN
    set nocount on;

    select * from [233082].Customer
    where (CustomerID = @CustomerID or @CustomerID is null)
    and (FirstName = @FirstName or @FirstName is null)
    and (LastName = @LastName or @LastName is null)
    and (EmailAddress = @EmailAddress or @EmailAddress is null)
END;
go

exec dbo.usp_GetCustomerData @CustomerID = 100
go
-- =============================================
-- Zadanie 3
-- =============================================
create type SalesLT.OrderHistoryType as table
(
    Product nvarchar(max),
    OrderDate datetime,
    Quantity int,
    TotalPrice money
);
GO

--create procedure dbo.GetCustomerOrderHistory
--    @CustomerID int,
--    @OrderHistory SalesLT.OrderHistoryType output --> SQL Server zabrania uzycia OUTPUT dla parametrów tabelarycznych, więc wykonanie zadania z uzyciem OUTPUT nie jest mozliwe.
--AS
--BEGIN
--    set nocount on;
--    select p.Name as Product, soh.OrderDate as OrderDate, sod.OrderQty as Quantity, sod.LineTotal as TotalPrice
--    from SalesLT.SalesOrderHeader soh join SalesLT.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
--    join SalesLT.Product p on sod.ProductID = p.ProductID
--    where soh.CustomerID = @CustomerID;
--end;
--go

-- =============================================
-- Zadanie 4
-- =============================================
create function [233082].ufn_CheckIfCustomerExists
(
    @EmailAddress nvarchar(50) -- za unikalny wyznacznik klienta uznajemy adres email
)
returns BIT
AS
BEGIN
    declare @Result bit = 0;

    if @EmailAddress is not null and exists (select 1 from [233082].Customer where EmailAddress = @EmailAddress) 
    BEGIN
        SET @Result = 1;
    END

    return @Result;
end;
go

create or alter procedure dbo.usp_AddCustomer
    @FirstName [dbo].[Name],
    @LastName [233082].[W2_surname],
    @EmailAddress nvarchar(50) = null,
    @Phone [dbo].[Phone] = null
AS
BEGIN
    set nocount on;

    if [233082].ufn_CheckIfCustomerExists(@EmailAddress) = 1
    BEGIN
        raiserror('Wystąpił błąd - uzytkownik o podanym adresie e-mail znajduje się juz w bazie danych.', 16, 1)
    END
    else
        insert into [233082].Customer (FirstName, LastName, EmailAddress, Phone, PasswordHash, PasswordSalt, rowguid, ModifiedDate)
        values (@FirstName, @LastName, @EmailAddress, @Phone, 'KPdtRdvqeAhj6wyxEsFdshBDNXxkCXn+CRgbvJIlknw=', 
        '1UjXPPs4=', 'e632f657-a7af-4a7d-a645-c429d6e02491', getdate());
end;
go

exec dbo.usp_AddCustomer @FirstName = 'Agata', @LastName = 'Kowalczyk', @EmailAddress = 'jovita0@adventure-works.com'
go

-- =============================================
-- Zadanie 5
-- =============================================
create procedure [233082].usp_UpdateCustomerData
    @CustomerID int,
    @FirstName [dbo].[Name],
    @LastName [233082].[W2_surname]
AS
BEGIN
    set nocount on;

        if not exists (select 1 from [233082].Customer where CustomerID = @CustomerID)
        BEGIN
            RAISERROR (N'Aktualizacja nie powiodła się: brak klienta o podanym ID', 16, 1)
        end

        update [233082].Customer
        set FirstName = @FirstName, LastName = @LastName, ModifiedDate = GETDATE()
        where CustomerID = @CustomerID;
end;
go


EXEC [233082].usp_UpdateCustomerData
    @CustomerID = 999999, 
    @FirstName = 'xyz',
    @LastName = 'qwer'
    go

-- =============================================
-- Zadanie 6
-- =============================================
create table SalesLT.ProductInventory
(
    ProductID int primary key,
    InventoryQuantity int,

    foreign key (ProductID)
    references SalesLT.Product
);
GO

create or alter procedure dbo.usp_AddNewProduct
    @ProductName nvarchar(50),
    @ProductCategory nvarchar(100),
    @ProductNumber nvarchar(25),
    @ListPrice money,
    @InventoryQuantity INT
AS
BEGIN
    set nocount on;
    set XACT_ABORT on;

    if @ListPrice <= 0
    BEGIN
        raiserror(N'Błąd: Cena produktu musi być większa od zera.', 16, 1)
    end
    else if @InventoryQuantity < 0
    BEGIN
        raiserror(N'Błąd: Ilość sztuk w magazynie nie może być ujemna.', 16, 1)
    end
    ELSE
        begin TRY
        begin tran;
            declare @CategoryID int
            select @CategoryID = ProductCategoryID from SalesLT.ProductCategory
            where [Name] = @ProductCategory;

            INSERT INTO SalesLT.Product (
            [Name],            
            [ProductCategoryID], 
            [ProductNumber], 
            [ListPrice], 
            [StandardCost], 
            [SellStartDate], 
            [rowguid], 
            [ModifiedDate]
        )
            values (@ProductName, @CategoryID, @ProductNumber, @ListPrice, @ListPrice, getdate(), newid(), getdate())

            declare @ProductID int
            set @ProductID = @@Identity

            insert into SalesLT.ProductInventory (ProductID, InventoryQuantity)
            values (@ProductID, @InventoryQuantity)
        commit tran;
        return 0; 
    end TRY
    begin CATCH
        if @@TRANCOUNT > 0 rollback;
        return -99;
    end CATCH
end;
GO

exec dbo.usp_AddNewProduct @ProductName = 'Mountain Bike Frame', @ProductCategory = 'Mountain Bikes', @ProductNumber = 'MB-1234', @ListPrice = 100.00, @InventoryQuantity = 300
go
-- =============================================
-- Zadanie 7
-- =============================================
select top 25 ProductID, Name, ListPrice
into #TopProducts
from SalesLT.Product
order by ListPrice desc;
go

declare @Summary table (
    ProductID int,
    Name nvarchar(50),
    OldPrice money,
    NewPrice money
)
go;

--create or alter procedure Student_2.TopProducts
--as
--begin
--    insert into @Summary (ProductID, Name, OldPrice, NewPrice) --> zadanie niemozliwe do wykonania, poniewaz procedura nie moze odwołać się
--do zmiennej tabelarycznej @Summary zadeklarowanej poza ciałem procedury
--    select ProductID, Name, ListPrice, (ListPrice - (ListPrice * 0.02))
--    from #TopProducts

--    select * from @Summary;
--end;
--go