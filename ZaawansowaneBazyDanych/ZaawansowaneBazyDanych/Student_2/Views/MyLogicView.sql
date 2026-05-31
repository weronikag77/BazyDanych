
create view Student_2.MyLogicView AS
select p.ProductID, p.Name as NazwaProduktu, p.ListPrice as Cena,
sum(sod.OrderQty) as SprzedanaIlosc, sum (sod.LineTotal) as CalkowityPrzychod FROM
SalesLT.Product p inner join SalesLT.SalesOrderDetail sod on p.ProductID = sod.ProductID
group by p.ProductID, p.Name, p.ListPrice;