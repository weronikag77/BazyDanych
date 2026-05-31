create function ufn_SearchByAuthor(@Author nvarchar(100))
returns TABLE
AS
return (
    select Title, Price, ReleaseYear from Books where Author = @Author
);