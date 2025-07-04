--EXERCIȚII

--Afisarea datelor dintr-o tabela.
--Sa se scrie fraze select care sa afiseze urmatoarele:
--Nume autor
select autori.nume_autor from autori
order by autori.pk_autor;
--Titlu carte, domeniu
select carti.titlu_carte, carti.domeniu from carti
order by carti.pk_carte;
--Nume cititor, varsta, sex, calificativ
select cititori.nume_cititor, cititori.varsta, cititori.sex, cititori.calificativ from cititori
order by cititori.pk_cititor;


	
	
--Afisarea datelor din mai multe tabele (SELECT)
--Sa se scrie fraze select pentru afisarea urmatoarelor informatii:

--1  Titlu carte, nume autori: 
select c.titlu_carte, a.nume_autor from carti c, autori a
where a.pk_autor in (c.pk_autor1, c.pk_autor2, c.pk_autor3)
order by c.titlu_carte;

--2  Toate imprumuturile de carti din biblioteca (titlu_carte, nume_cititor, data_start, data_end, data_return)
select c.titlu_carte, cit.nume_cititor, i.data_start, i.data_end, i.data_return from carti c, cititori cit, imprumuturi i
where c.pk_carte = i.pk_carte 
and cit.pk_cititor = i.pk_cititor
order by i.data_start;

--3  Toate imprumuturile care nu au fost returnate pana in ziua de azi. Ziua curenta se afla cu ajutorul comenzii sysdate.
select c.titlu_carte, cit.nume_cititor, i.data_start, i.data_end from carti c,  cititori cit, imprumuturi i
where c.pk_carte = i.pk_carte 
and cit.pk_cititor = i.pk_cititor
and i.data_return is null
order by i.data_end;

--4  Toate imprumuturile care nu au fost returnate pana in ziua de azi si numarul de zile de cand au fost imprumutate, numarul de zile de intarziere.
select c.titlu_carte, cit.nume_cititor, i.data_start, i.data_end, trunc(sysdate - i.data_start) as zile_de_la_imprumut, greatest(trunc(sysdate - i.data_end),0) as zile_intarziere from carti c,  cititori cit, imprumuturi i
where c.pk_carte = i.pk_carte 
and cit.pk_cititor = i.pk_cititor
and i.data_return is nu

--5  Toate imprumuturile mai vechi de 2 saptamani
select titlu_carte, nume_cititor, data_start, data_end, data_return from carti c, cititori ci, imprumuturi i
where c.pk_carte = i.pk_carte
and ci.pk_cititor = i.pk_cititor
and ((data_return is not null and data_return < sysdate - 14) or (data_end < sysdate - 14))
order by data_return;

--6  Numarul de carti care trebuie sa fie returnate in urmatoarea saptamana: selectul afiseaza ziua si numarul  de carti care trebuie sa fie returnate.
select trunc(data_end) as data_returnare, count(*) as numar_carti_returnare from imprumuturi
    where data_end between sysdate and sysdate + 7
    and data_return is null            
    group by trunc(data_end)                          
    order by trunc(data_end);
	
--7  Toate cartile care exista in mod fizic in biblioteca (nu sunt imprumutate in acest moment). Aici intra cartile care nu au fost imprumutate niciodata plus cartile care au fost imprumutate si returnate pana in ziua curenta. Selectul trebuie sa trateze si cazul cand o carte a fost imprumutata de mai multe ori (a fost returnata si apoi imprumtata catre alt cititor).
select carti.titlu_carte from carti
    where not exists (
    select 1 from imprumuturi
    where carti.pk_carte = imprumuturi.pk_carte
    and imprumuturi.data_return is null)
    order by carti.titlu_carte;
	
--8  Toate imprumuturile pentru un cititor dat  
select carti.titlu_carte, cititori.nume_cititor, imprumuturi.data_start, imprumuturi.data_end, imprumuturi.data_return,imprumuturi.observatii from carti, cititori, imprumuturi
    where carti.pk_carte = imprumuturi.pk_carte 
    and cititori.pk_cititor = imprumuturi.pk_cititor
    and cititori.pk_cititor = 2 --introducem id-ul cititorului pentru care dorim sa vedem imprumuturile
    order by imprumuturi.pk_imprumut;
	
--9  Toate imprumuturile care nu au fost returnate la termen de catre un cititor dat (data_return > data_end or data_return is null and sysdate>data_end) 
select carti.titlu_carte, imprumuturi.data_start, imprumuturi.data_end, imprumuturi.data_return, imprumuturi.observatii from carti, imprumuturi
   where carti.pk_carte = imprumuturi.pk_carte
   and imprumuturi.pk_cititor = 5
   and (imprumuturi.data_return is null and sysdate > imprumuturi.data_end
   or imprumuturi.data_return > imprumuturi.data_end)
   order by imprumuturi.data_start;
   
--10 Cititorii care au mai mult de un imprumut in ziua curenta: nume cititor, titlu_carte, data_start, data_end -Stop
select cititori.nume_cititor, carti.titlu_carte, imprumuturi.data_start, imprumuturi.data_end from cititori, carti, imprumuturi
   where cititori.pk_cititor = imprumuturi.pk_cititor
   and carti.pk_carte = imprumuturi.pk_carte
   and imprumuturi.data_start <= sysdate
   and imprumuturi.data_end >= sysdate
   and imprumuturi.pk_cititor in (
    select pk_cititor
    from imprumuturi
    where data_start <= sysdate
    and data_end >= sysdate
    group by pk_cititor
    having count(*) > 1
)
order by cititori.nume_cititor, imprumuturi.data_start;

--11 Numele cititorilor si numarul de imprumuturi efectuate de acel cititor in decursul timpului: nume_autor, numar_imprumuturi
select cititori.nume_cititor, count(imprumuturi.pk_imprumut) as numar_imprumuturi from cititori, imprumuturi
   where cititori.pk_cititor = imprumuturi.pk_cititor
   group by cititori.nume_cititor
   order by numar_imprumuturi desc;
   
--12 Lista cu primii 3 cititori in ordinea numarului de imprumuturi
select cititori.nume_cititor, count(imprumuturi.pk_imprumut) as numar_imprumuturi from cititori, imprumuturi
   where cititori.pk_cititor = imprumuturi.pk_cititor
   group by cititori.nume_cititor
   order by numar_imprumuturi desc
   fetch first 3 rows only;
   
--13 Lista cu primii 3 cititori care au cele mai multe intarzieri la returnarea cartilor
select cititori.nume_cititor, sum(imprumuturi.data_return - imprumuturi.data_end) as total_intarzieri
from cititori, imprumuturi
where cititori.pk_cititor = imprumuturi.pk_cititor
and imprumuturi.data_return > imprumuturi.data_end
group by cititori.nume_cititor
order by total_intarzieri desc
fetch first 3 rows only;

--14 Lista primilor 3 cititori cu calificative negative. Calificativul unui cititor este dat de raportul dintre numarul de carti imprumutate si numarul de intarzieri la returnare. Este posibil ca un cititor sa aiba multe intarzieri (deci este in capul listei la numar de intarzieri), dar si multe imprumuturi, deci calificativul acestui cititor este mai bun decat al unui alt cititor cu o singura intarziere dar si un singur imprumut.
select 
    cititori.nume_cititor, 
    count(imprumuturi.pk_imprumut) as numar_imprumuturi,
    sum(case when imprumuturi.data_return > imprumuturi.data_end then 1 else 0 end) as numar_intarzieri,
    case 
        when sum(case when imprumuturi.data_return > imprumuturi.data_end then 1 else 0 end) > 0 
        then count(imprumuturi.pk_imprumut) / sum(case when imprumuturi.data_return > imprumuturi.data_end then 1 else 0 end) 
        else 0 
    end as calificativ
from cititori, imprumuturi
where cititori.pk_cititor = imprumuturi.pk_cititor
group by cititori.nume_cititor
having count(imprumuturi.pk_imprumut) > 0 
order by calificativ desc
fetch first 3 rows with ties;

--15 Cartile cele mai solicitate pentru imprumut (cu numarul cel mai mare de imprumuturi)
select 
    carti.titlu_carte, 
    count(imprumuturi.pk_imprumut) as numar_imprumuturi
from carti, imprumuturi
where carti.pk_carte = imprumuturi.pk_carte
group by carti.titlu_carte
order by numar_imprumuturi desc;

--16 Cei mai bine cititi autori  (autorii ai caror carti au fost cel mai mult solicitate)
select 
    autori.nume_autor, 
    count(imprumuturi.pk_imprumut) as numar_imprumuturi
from autori, carti, imprumuturi
where carti.pk_autor1 = autori.pk_autor
and carti.pk_carte = imprumuturi.pk_carte
group by autori.nume_autor
order by numar_imprumuturi desc;



--UPDATE
--1 Sa se scrie instructiuni update care modifica numele unui autor si titlul unei carti.
update autori
   set nume_autor = 'Neil Gaiman'
   where pk_autor = 1;
update carti
   set titlu_carte = 'Good Omens'
   where pk_carte = 1;
   
--2 Sa se scrie instructiunea update care trece toate impumuturile de la un cititor pe numele altui cititor.
update imprumuturi
set pk_cititor = 1  -- Noul ID al cititorului
where pk_cititor = 3;  -- ID-ul cititorului vechi al cărui împrumuturi trebuie actualizate

--3 Completeaza cu data curenta campul “data_return” din tabela”imprumuturi” pentru un cititor dat si o carte data (cititorul a returnat cartea la biblioteca).
update imprumuturi
set data_return = sysdate
where pk_cititor = 1
and pk_carte = 3
and data_return is null;

--4 Prelungeste perioada imprumutului cu 3 saptamani pentru toate cartile din domeniul “stiinte”.
update imprumuturi i
set i.data_end = i.data_end + 21  
where i.pk_carte IN (
    select c.pk_carte
    from carti c
    where c.domeniu = 'Stiinte' 
);

--5 Toate titlurile cartilor sa fie scrise cu majuscule
update carti
set titlu_carte = upper(titlu_carte);

--6 Titlurile cartilor scrise de un autor (prim_autor) sa inceapa cu majuscula si apoi sa continue cu litera mica
update carti
set titlu_carte = initcap(titlu_carte)
where pk_autor1 = 'Neil Gaiman';



--Sa se scrie instructiuni DELETE care sa stearga urmatoarele informatii:
--1 Imprumuturile pentru un anumit cititor
delete from imprumuturi
where pk_cititor = 1;

--2 Un cititor din baza de date. Se folosesc 2 metode:
--Se sterg toate informatiile din tabele copil care tin de tabela “cititori”. (Ex: tabela “imprumuturi”). Apoi se sterge informatia din tabela parinte. 
--In caz contrar la executia instructiunii delete din tabela parinte apare eroare datorata constrangerilor de tip “foreign key” care leaga cititorul de imprumuturi.
delete from imprumuturi
where pk_cititor = 1;
delete from cititori
where pk_cititor = 1;
--Se executa comanda delete cu optiunea “on delete cascade”: in acest caz se sterg toate informatiile din tabelele copil care sunt legate prin constrangeri “foreign key” de tabela parinte.
ALTER TABLE imprumuturi ADD CONSTRAINT fk_imprumuturi_cititori FOREIGN KEY (pk_cititor) REFERENCES cititori (pk_cititor) ON DELETE CASCADE;
delete from cititori
where pk_cititor = 1;





--Sa se scrie functii PL/SQL care sa rezolve urmatoarele taskuri:

--1 Verifica daca o carte este disponibila sau imprumutata: returneaza 0 daca este disponibila in biblioteca, 1 in caz ca este imprumutata:

--CREATE OR REPLACE 
--FUNCTION carte_disponibila(titlu_carte in varchar2) return number is
--begin
--	…
--return …;
--end;
--/

create or replace function carte_disponibila (p_pk_carte in number)
return number
is
    v_count number;
begin
    select count(*)
    into v_count
    from imprumuturi
    where pk_carte = p_pk_carte
      and data_return is null;

    if v_count > 0 then
        return 1; 
    else
        return 0;
    end if;
end carte_disponibila;
/

select carte_disponibila(9) as unu_pentru_imprumut from dual;


--2 Calculeaza numarul de carti pentru un autor dat

--create or replace 
--function nr_carti_per_autor(nume_autor in varchar2) return number is
--begin
    -- your logic here
--    return ...;
--end;
--/

create or replace 
function nr_carti_per_autor(pk_autor in number) 
return number 
is
    v_count number := 0;
begin
    select count(c.pk_carte)
    into v_count
    from carti c
    where (c.pk_autor1 = pk_autor and c.pk_autor1 is not null)
       or (c.pk_autor2 = pk_autor and c.pk_autor1 is not null) 
       or (c.pk_autor3 = pk_autor and c.pk_autor1 is not null);

    return v_count;
end;
/
select nr_carti_per_autor(9) from dual;




--TRIGGERS
--1 sa se scrie triggerul din exemplu si sa se verifice functionalitatea la inserarea unei noi linii in tabela imprumuturi.

drop sequence pk_imprumut; 
drop trigger trig_imprumuturi;

create sequence pk_imprumut
  increment by 1
  start with 1
  minvalue 1
  maxvalue 9999999999999;


create or replace trigger trig_imprumuturi
  before insert on imprumuturi
  referencing new as new old as old
  for each row
begin
  select pk_imprumut.nextval into :new.pk_imprumut from dual;
end;
/

delete from imprumuturi;
insert into imprumuturi (pk_carte, pk_cititor, data_start, data_end, data_return, observatii) values (1, 1, sysdate - 4, sysdate + 6, null, 'observatii');
select * from imprumuturi;


--2 Pe baza modelului sa se scrie un trigger care sa completeze automat coloana pk_carte la inserarea unei carti in tabela "carti".

drop sequence pk_carte;  
drop trigger before_insert_carti;

create sequence pk_carte
  increment by 1
  start with 13
  minvalue 1
  maxvalue 9999999999999;
  
create or replace trigger before_insert_carti
  before insert on carti
  for each row
begin
  select pk_carte.nextval into :new.pk_carte from dual;
end;
/

delete from carti;
insert into carti (domeniu, titlu_carte, pk_autor1, pk_autor2, pk_autor3) values ('beletristica', 'Test Book', 1, null, null);
select * from carti;


--3 Sa se scrie un trigger care completeaza automat data_start si data_end pentru un nou imprumut (data_start = sysdate, data_end = data_start + 3 saptamani)

create or replace trigger before_insert_imprumuturi
  before insert on imprumuturi
  for each row
begin
  -- setăm data_start la data curentă
  :new.data_start := sysdate;

  -- setăm data_end la 3 săptămâni de la data_start
  :new.data_end := sysdate + 21; -- 21 zile = 3 săptămâni
end;
/

delete from imprumuturi;
insert into imprumuturi values(1, 1, 1, null, null, null, null);
select * from imprumuturi;









    
