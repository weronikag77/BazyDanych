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