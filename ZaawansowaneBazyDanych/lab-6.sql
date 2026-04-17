-- =============================================
-- Weronika
-- Gurba
-- 233082
-- =============================================

-- =============================================
-- Zadanie 1
-- =============================================

-- sesja 1
BEGIN TRANSACTION;

update [233082].Customer
set LastName = 'XYZ'
where CustomerID = 25

-- sesja 2
select * from [233082].Customer
go

-- W zapytaniu w sesji 1 nie użyto "COMMIT" ani "ROLLBACK", przez co transakcja będzie "wisieć",
-- a próba odczytu danych z tabeli w sesji 2 nie powiedzie się.

-- W opisanym powyżej przypadku zarówno my, jak i inni użytkownicy stracimy możliwość odczytu 
-- oraz zapisu danych w tabeli.
-- Otwarta, niezakończona transakcja będzie cały czas zajmować miejsce w Transaction Log, którego
-- rozmiary mogą po dłuższym czasie stać się ogromne.
-- Dodatkowo, jako że uniemożliwione będzie korzystanie z tabeli [233082].Customer, po chwili 
-- zatrzymają się także inne procesy, które będą chciały z niej skorzystać.

-- =============================================
-- Zadanie 2
-- =============================================

BEGIN TRAN;

update SalesLT.Product
set Size = 'None'
where Size is NULL;
go

select * from SalesLT.Product;
go

insert into SalesLT.Address (AddressLine1, City, StateProvince, CountryRegion, PostalCode)
values
    ('Test Address 1', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 2', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 3', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 4', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 5', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 6', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 7', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 8', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 9', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 10', 'Warsaw', 'mazowieckie', 'Poland', '00-001');
go

select count(*) from SalesLT.Address; -- status tabeli SalesLT.Address po dodaniu 10 rekordów

--truncate table SalesLT.ProductModel; -> polecenie zostało zakomentowane, ponieważ w bazie danych nie ma tabeli, która nie
--zawierałaby klucza obcego dla innej tabeli (FK blokuje Truncate)
--select count(*) from SalesLT.ProductModel; -- status tabeli SalesLT.ProductModel po wyczyszczeniu jej

ROLLBACK TRAN;

select * from SalesLT.Product; -- status tabeli Product po cofnięciu zmian (wartość NULL z powrotem w kolumnie Size)
select count(*) from SalesLT.Address;
--select count(*) from SalesLT.ProductModel; -- status tabel Address i ProductModel po cofnięciu zmian (zmiany w liczbie rekordów)

-- =============================================
-- Zadanie 3
-- =============================================

BEGIN TRAN;

update SalesLT.Product
set Size = 'None'
where Size is NULL;
go

insert into SalesLT.Address (AddressLine1, City, StateProvince, CountryRegion, PostalCode)
values
    ('Test Address 1', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 2', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 3', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 4', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 5', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 6', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 7', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 8', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 9', 'Warsaw', 'mazowieckie', 'Poland', '00-001'),
    ('Test Address 10', 'Warsaw', 'mazowieckie', 'Poland', '00-001');
go


--truncate table SalesLT.ProductModel; -> zapytanie niemożliwe do wykonania ze względu na brak tabeli bez FK w bazie danych
--go

WAITFOR DELAY '00:05:00'
GO
ROLLBACK TRAN;

-- zapytanie zwracające dane z modyfikowanych tabel (osobna sesja):
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
select * from SalesLT.Product;
select count(*) from SalesLT.Address;
--select count(*) from SalesLT.ProductModel;
--go

-- =============================================
-- Zadanie 4
-- =============================================

begin try
    select ListPrice/0 from SalesLT.Product;
end try

begin catch
    SELECT  
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_MESSAGE() AS ErrorMessage,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine;
end catch
go

-- =============================================
-- Zadanie 5
-- =============================================

-- Celem operacji jest aktualizacja ceny ("ListPrice") dla konkretnego produktu.
-- Wykorzystane zmienne to: @TargetProductID - ID produktu oraz @NewPrice - nowa cena.
-- Nowa cena nie może byc ujemna ani równa 0. ID produktu musi odpowiadać ID juz istniejącemu w bazie.
-- TRY... CATCH wyłapuje takie błędy jak np. naruszenie klucza. 

declare @TargetProductID int = 680;
declare @NewPrice money = 1500.00

begin try
    if not exists (select * from SalesLT.Product where ProductID = @TargetProductID)
        throw 50001, 'Nie znaleziono produktu o takim ID.', 1;

    if @NewPrice <= 0
        throw 50002, 'Cena musi być większa od 0.', 1;

    update SalesLT.Product
    set ListPrice = @NewPrice, ModifiedDate = getdate()
    where ProductID = @TargetProductID;

    print 'Cena została zaktualizowana.';
end TRY

begin catch
    SELECT  
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_MESSAGE() AS ErrorMessage,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine;
    print 'Operacja anulowana.'
end catch
go
-- =============================================
-- Zadanie 6
-- =============================================

declare @TargetProductID int = 680;
declare @NewPrice money = 1500.00 

begin tran; 

begin try
    if not exists (select * from SalesLT.Product where ProductID = @TargetProductID)
        throw 50001, 'Nie znaleziono produktu o takim ID.', 1;

    if @NewPrice <= 0
        throw 50002, 'Cena musi być większa od 0.', 1;

    update SalesLT.Product
    set ListPrice = @NewPrice, ModifiedDate = getdate()
    where ProductID = @TargetProductID;

    print 'Cena została zaktualizowana.';
    commit tran;
end TRY

begin catch
    if @@TRANCOUNT > 0
        rollback tran;

    SELECT  
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_MESSAGE() AS ErrorMessage,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine;
    print 'Operacja anulowana.'
end catch
go