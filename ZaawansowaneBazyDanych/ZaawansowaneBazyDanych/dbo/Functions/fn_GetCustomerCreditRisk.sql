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