create   procedure dbo.usp_GetCustomerData
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