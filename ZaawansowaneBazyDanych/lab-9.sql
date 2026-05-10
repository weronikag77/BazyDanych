-- =============================================
-- Weronika
-- Gurba
-- 233082
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================
alter view SalesLT.v233082_order
AS
select 
    ProductID,
    Name, 
    ListPrice
from SalesLT.Product;
GO

-- Zmiana w widoku była konieczna, ponieważ poprzednio składał się tylko z dwóch kolumn.

create function SalesLT.BestRecord(
    @Name nvarchar(50) = '%',
    @MinPrice money  =0,
    @MaxPrice money = 999999)

 returns int
 as 
 begin
     declare @ResultID int;
     select top 1 @ResultID = ProductID
     from SalesLT.v233082_order
     where Name like @Name and ListPrice between @MinPrice and @MaxPrice
     order by ListPrice desc;

     return @ResultID;
end;
go

SELECT SalesLT.BestRecord('%Bike%', 100, 99999)
go

-- =============================================
-- Zadanie 2
-- =============================================
select top 25 ProductID, Name, ListPrice
into ##TopProducts
from SalesLT.Product
order by ListPrice desc;
go

create function Student_2.ufn_CalcAdjustedPrices()
returns table
as
RETURN
(
    select ProductID, Name, ListPrice as StaraCena, (ListPrice - (ListPrice * 0.02)) AS NowaCena
    from ##TopProducts
);
go

declare @Summary table (
    ProductID int,
    Name nvarchar(max),
    StaraCena money,
    NowaCena money
);

insert into @Summary
select * from Student_2.ufn_CalcAdjustedPrices()

select * from @Summary
go

-- Zadanie nie może zostać wykonane, ponieważ funkcja nie może odwołać się do tabeli tymczasowej.

-- =============================================
-- Zadanie 3
-- =============================================

create or alter function Student_2.ufn_ProductsJsonByCategory(
    @CategoryName nvarchar(50)
)
returns nvarchar(max)
AS
BEGIN   
    declare @Product nvarchar(max)

    set @Product = (
    select pc.Name as Category, p.Name as ProductName, p.ListPrice
    from SalesLT.ProductCategory pc join SalesLT.Product p 
    on pc.ProductCategoryID = p.ProductCategoryID
    where pc.Name = @CategoryName
    for json path);
    return @Product
end;
go

SELECT Student_2.ufn_ProductsJsonByCategory('Wheels') AS MyJsonResult;
go

-- =============================================
-- Zadanie 4
-- =============================================
create function Student_2.ufn_IsPriceHigherThanCurrent(
    @Product nvarchar(max)
)
returns bit
as
BEGIN
    declare @IsHigher bit = 0;
    declare @ProductID int;
    declare @JsonPrice money;
    declare @ActualPrice money;

    select @ProductID = ProductID, @JsonPrice = ListPrice
    from openjson(@Product)
    with (ProductID int, ListPrice money);

    select @ActualPrice = ListPrice
    from SalesLT.Product
    where ProductID = @ProductID;

    if @JsonPrice > @ActualPrice
    begin 
        set @IsHigher = 1;
    END
    ELSE
    BEGIN
        set @IsHigher = 0;
    end

    return @IsHigher;
end;
go

-- kiedy cena będzie równa, funkcja zwróci 0

declare @TestJson nvarchar(max) = '{"ProductID":707, "ListPrice":555.00}'
select Student_2.ufn_IsPriceHigherThanCurrent(@TestJson) as IsItHigher
go

-- =============================================
-- Zadanie 5
-- =============================================
create function Student_2.ufn_ProductPriceStatus(
    @ProductsJson nvarchar(max)
)
returns TABLE
as
return
(
    select ProductID, Name, ListPrice, 
    Student_2.ufn_IsPriceHigherThanCurrent('{"ProductID":' + cast(ProductID as varchar) + ', "ListPrice":' 
    + cast(ListPrice as varchar) + '}') as IsHigherThanInDB
    from openjson(@ProductsJson)

    with (
        ProductID int,
        Name nvarchar(max),
        ListPrice money
    )
);
go

declare @TestJson_2 nvarchar(max) = '[
    {"ProductID": 707, "Name": "Helmet", "ListPrice": 500.00},
    {"ProductID": 708, "Name": "Socks", "ListPrice": 1.00}]';
select * FROM Student_2.ufn_ProductPriceStatus(@TestJson_2);

-- =============================================
-- Zadanie 6
-- =============================================

-- Propozycja: system zarządzania biblioteką

create table Books (
    BookID int identity primary key,
    Title nvarchar(100),
    Author nvarchar(100),
    ReleaseYear bigint,
    Price money
);
go

INSERT INTO Books (Title, Author, ReleaseYear, Price)
VALUES 
    ('Wiedźmin: Ostatnie życzenie', 'Andrzej Sapkowski', 1993, 39.99),
    ('Projekt Hail Mary', 'Andy Weir', 2021, 45.50),
    ('Harry Potter i Kamień Filozoficzny', 'J.K. Rowling', 1997, 29.00),
    ('Diuna', 'Frank Herbert', 1965, 55.00),
    ('Mały Książę', 'Antoine de Saint-Exupéry', 1943, 15.00),
    ('Nowy wspaniały świat', 'Aldous Huxley', 1932, 19.50),
    ('Cyberiada', 'Stanisław Lem', 1965, 34.00);
   go

-- 1) Widok - pozwala bibliotekarzom wyświetlić podgląd nowszych ksiązek w bazie (w tym przypadku od 2020 roku).

create view v_NewBooks AS
select Title, Author, ReleaseYear
from Books
where ReleaseYear > 2020;
GO

select * from v_NewBooks;
go

-- 2) Funkcja skalarna - pozwala na wyświetlenie krótkiej informacji o ksiązce, zawierającej autora i tytuł.

create function ufn_TitleAuthor(@Title nvarchar(100), @Author nvarchar(100))
returns nvarchar(250)
AS
BEGIN
    return upper(@Title) + ' (' + @Author + ')'
end;
go

select dbo.ufn_TitleAuthor('Wiedźmin', 'Andrzej Sapkowski')
go

-- 3) iTVF - wyszukiwarka, która zwraca listę ksiązek danego autora.

create function ufn_SearchByAuthor(@Author nvarchar(100))
returns TABLE
AS
return (
    select Title, Price, ReleaseYear from Books where Author = @Author
);
go

select * from dbo.ufn_SearchByAuthor('Frank Herbert')
go

-- 4) mTVF - pozwala podzielić ksiązki na trzy kategorie cenowe: "Cheap", "Standard", "Premium".

create function ufn_PriceReport()
returns @Result table (Title nvarchar(100), Category nvarchar(50))
AS
BEGIN
    insert into @Result
    select Title,
    case
        when Price < 20 then 'Cheap'
        when Price between 20 and 50 then 'Standard'
        when Price > 50 then 'Premium'
        END
    from Books;
    return;
end;
GO

select * from dbo.ufn_PriceReport()
go
-- =============================================
-- Zadanie 7
-- =============================================
create function dbo.fn_GetCustomerCreditRisk(@CustomerID int)
returns nvarchar(50)
AS
begin
    declare @Orders table (
        TotalDue money,
        IsDelayed bit
    );

    insert into @Orders (TotalDue, IsDelayed)
    select 
    TotalDue,
    case when ShipDate > dateadd(day, 3, DueDate) then 1 else 0 end
    from SalesLT.SalesOrderHeader
    where CustomerID = @CustomerID;

    declare @TotalSum money;
    declare @DelayedCount int;

    select @TotalSum = sum(TotalDue),
        @DelayedCount = sum(cast(IsDelayed as int))
    from @Orders;

    declare @Risk nvarchar(50)
    if @TotalSum = 100000 and @DelayedCount >= 2 set @Risk = 'High'
    else if @TotalSum > 50000 set @Risk = 'Medium'
    else set @Risk = 'Low';

    return @Risk;
end;
go

select dbo.fn_GetCustomerCreditRisk(29736);
go
