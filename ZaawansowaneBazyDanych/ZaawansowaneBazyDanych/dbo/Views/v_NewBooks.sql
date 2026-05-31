create view v_NewBooks AS
select Title, Author, ReleaseYear
from Books
where ReleaseYear > 2020;