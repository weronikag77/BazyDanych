create function SalesLT.BestRecord(
    @Name nvarchar(50) = '%',
    @MinPrice money  =0,
    @MaxPrice money = 999999)

 returns int
 as 
 begin
     declare @ResultID int;
     select top 1 @ResultID = ProductID
     from SalesLT.v233082_order
     where Name like @Name and ListPrice between @MinPrice and @MaxPrice
     order by ListPrice desc;

     return @ResultID;
end;