create function Student_2.ufn_IsPriceHigherThanCurrent(
    @Product nvarchar(max)
)
returns bit
as
BEGIN
    declare @IsHigher bit = 0;
    declare @ProductID int;
    declare @JsonPrice money;
    declare @ActualPrice money;

    select @ProductID = ProductID, @JsonPrice = ListPrice
    from openjson(@Product)
    with (ProductID int, ListPrice money);

    select @ActualPrice = ListPrice
    from SalesLT.Product
    where ProductID = @ProductID;

    if @JsonPrice > @ActualPrice
    begin 
        set @IsHigher = 1;
    END
    ELSE
    BEGIN
        set @IsHigher = 0;
    end

    return @IsHigher;
end;