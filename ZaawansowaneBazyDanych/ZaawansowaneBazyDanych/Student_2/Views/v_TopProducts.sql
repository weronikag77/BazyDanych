create view Student_2.v_TopProducts as
select NazwaProduktu, SprzedanaIlosc, CalkowityPrzychod
from Student_2.MyLogicView
where SprzedanaIlosc > 50