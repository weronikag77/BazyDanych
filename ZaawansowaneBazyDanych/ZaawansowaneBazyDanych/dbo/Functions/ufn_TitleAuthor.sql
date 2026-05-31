create function ufn_TitleAuthor(@Title nvarchar(100), @Author nvarchar(100))
returns nvarchar(250)
AS
BEGIN
    return upper(@Title) + ' (' + @Author + ')'
end;