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