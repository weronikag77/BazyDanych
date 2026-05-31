-- =============================================
-- Weronika
-- Gurba
-- 233082
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================
select DISTINCT
    pc.Name as CategoryName, min(p.ListPrice) over (partition by p.ProductCategoryID) as MinPrice,
    max(p.ListPrice) over (partition by p.ProductCategoryID) as MaxPrice,
    count(p.ProductID) over (partition by p.ProductCategoryID) as ProductCount
from SalesLT.Product p inner join SalesLT.ProductCategory pc on p.ProductCategoryID = pc.ProductCategoryID;
GO

-- =============================================
-- Zadanie 2
-- =============================================

-- scenariusz: wyświetlenie struktury wynagrodzeń w firmie. zapytanie wyświetla listę wszystkich pracowników wraz z ich pensjami,
-- wartością średniej pensji w ich dziale oraz liczbą osób, które w nim pracują.

create table dbo.Employees (
    EmployeeID int identity primary key,
    FirstName nvarchar(50),
    LastName nvarchar(50),
    Department nvarchar(50),
    Salary money
);
GO

insert into dbo.Employees (FirstName, LastName, Department, Salary) VALUES
    ('Sebastian', 'Richardson', 'IT', '9500.00'),
    ('Riley', 'Carr', 'IT', '11000.00'),
    ('Jude', 'Williams', 'IT', '7500.00'),
    ('Jonathan', 'Elliott', 'HR', '6500.00'),
    ('Willow', 'Booth', 'HR', '6000.00'),
    ('Elisabeth', 'Burnett', 'Sales', '5500.00'),
    ('Maddison', 'Cole', 'Sales', '11000.00'),
    ('Phoenix', 'Edwards', 'Sales', '6800.00');
GO

select EmployeeID, FirstName + ' ' + LastName as EmployeeName, Department, Salary,
    avg(salary) over (partition by Department) as AvgDepartmentSalary,
    count(EmployeeID) over (partition by Department) as TotalEmployeesCount
from dbo.Employees;
GO

-- =============================================
-- Zadanie 3
-- =============================================

-- scenariusz: analiza preferencji gatunkowych klientów wypozyczalni filmów.
-- za pomocą operatora Pivot zliczamy, ile razy dany klient wybrał konkretny gatunek (nazwy gatunków stają się osobnymi kolumnami).
-- z kolei Unpivot działa odwrotnie i "zwija" kolumny z powrotem do postaci wierszy. 

create table dbo.MovieRentals(
    RentalID int identity primary key,
    CustomerID int,
    Genre nvarchar(50)
);
GO

insert into dbo.MovieRentals (CustomerID, Genre)
values (11, 'Sci-Fi'), (11, 'Sci-Fi'), (11, 'Comedy'),
(12, 'Sci-Fi'), (12, 'Comedy'), (12, 'Comedy');
go

-- pivot
select *
into #pivotTable
from (
    select CustomerID, RentalID, Genre
    from dbo.MovieRentals
) as src 
pivot (
    count(RentalID) for Genre in ([Sci-Fi], [Comedy])
) as pvt;

select * from #pivotTable;
GO

-- unpivot
select CustomerID, Genre, RentalCount
from #pivotTable
unpivot (
    RentalCount for Genre in ([Sci-Fi], [Comedy])
) as unpvt;
GO

-- =============================================
-- Zadanie 4
-- =============================================

-- scenariusz: celem jest analiza upodobań czytelniczych w bibliotece. chcemy wygenerować raport, który prezentuje szczegółowe
-- liczby wypozyczeń, wylicza podsumowania dla kazdego gatunku oraz zwraca ogólny wynik dla biblioteki.

create table dbo.BookStatistics (
    BookID int identity primary key,
    Title nvarchar(100),
    Author nvarchar(50),
    Genre nvarchar(50),
    RentalCount int
);
GO

insert into dbo.BookStatistics (Title, Author, Genre, RentalCount)
values 
    ('Wiedźmin: Ostatnie Życzenie', 'Andrzej Sapkowski', 'Fantasy', 120),
    ('Wiedźmin: Miecz Przeznaczenia', 'Andrzej Sapkowski', 'Fantasy', 105),
    ('Wiedźmin: Krew Elfów', 'Andrzej Sapkowski', 'Fantasy', 150),
    ('Morderstwo w Orient Expressie', 'Agatha Christie', 'Crime fiction', 180),
    ('Kasacja', 'Remigiusz Mróz', 'Crime fiction', 85),
    ('Zaginięcie', 'Remigiusz Mróz', 'Crime fiction', 85),
    ('Hobbit', 'J.R.R. Tolkien', 'Fantasy', 150);
GO

-- agregacja zaawansowana
select Genre, Author, sum(RentalCount) as TotalRentalCount,
    grouping(Genre) as IsGenreTotal, grouping(Author) as IsAuthorTotal
from dbo.BookStatistics
group by rollup(Genre, Author);
GO




