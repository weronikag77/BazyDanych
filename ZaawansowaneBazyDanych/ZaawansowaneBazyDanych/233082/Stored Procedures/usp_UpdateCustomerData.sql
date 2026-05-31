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