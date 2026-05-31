create   procedure dbo.usp_AddCustomer
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