-- =============================================
-- Weronika
-- Gurba
-- 233082
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

create type [233082].W2_surname from nvarchar(50) not null;
go

alter table [233082].Customer
alter column LastName [233082].W2_surname;
go

-- =============================================
-- Zadanie 2
-- =============================================

declare @ProductInfo nvarchar(max) = N'[
{"ProductID": 680, "NewPrice": 1550.0},
{"ProductID": 707, "NewPrice": 36.0},
{"ProductID": 712, "NewPrice": 10.0},
{"ProductID": 725, "NewPrice": 340.0},
{"ProductID": 737, "NewPrice": 360.0}
]'
go

create view SalesLT.v_ProductPrice AS
select ProductID, ListPrice, NewPrice
from SalesLT.Product p inner join openjson(@ProductInfo, '$.ProductID') np 
on p.ProductID = np.ProductID;
go

-- Zadanie nie może zostać wykonane w sposób całkowicie zgodny z treścią, ponieważ nie ma możliwosci odwołania się do zmiennej
-- utworzonej w innym batchu (program jej nie widzi). 

-- =============================================
-- Zadanie 3
-- =============================================

create view SalesLT.v_233082_order AS
select top 100
    Name, ListPrice
from SalesLT.Product 
order by ListPrice asc;
go

-- =============================================
-- Zadanie 4
-- =============================================

-- Celem jest utworzenie zestawienia, które pokaże zainteresowanie poszczególnymi produktami sprzedawanymi 
-- przez firmę. Widok oblicza łączną ilość sprzedanych sztuk produktów i całkowity przychód, jaki przyniosły one firmie.

create view Student_2.MyLogicView AS
select p.ProductID, p.Name as NazwaProduktu, p.ListPrice as Cena,
sum(sod.OrderQty) as SprzedanaIlosc, sum (sod.LineTotal) as CalkowityPrzychod FROM
SalesLT.Product p inner join SalesLT.SalesOrderDetail sod on p.ProductID = sod.ProductID
group by p.ProductID, p.Name, p.ListPrice;
GO

select * from Student_2.MyLogicView
order by SprzedanaIlosc desc;
go

-- =============================================
-- Zadanie 5
-- =============================================

create view Student_2.v_TopProducts as
select NazwaProduktu, SprzedanaIlosc, CalkowityPrzychod
from Student_2.MyLogicView
where SprzedanaIlosc > 50;
go

select * from Student_2.v_TopProducts;
go