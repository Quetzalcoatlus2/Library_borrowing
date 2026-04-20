-- EXERCISES

-- Displaying data from one table.
-- Write SELECT statements that display the following:
-- Author name
select authors.author_name from authors
order by authors.author_id;
-- Book title, domain
select books.book_title, books.category from books
order by books.book_id;
-- Reader name, age, sex, rating
select readers.reader_name, readers.age, readers.sex, readers.rating from readers
order by readers.reader_id;


	
	
-- Displaying data from multiple tables (SELECT)
-- Write SELECT statements to display the following information:

-- 1  Book title, author name:
select c.book_title, a.author_name from books c, authors a
where a.author_id in (c.primary_author_id, c.secondary_author_id, c.tertiary_author_id)
order by c.book_title;

-- 2  All library book loans (book_title, reader_name, start_date, end_date, return_date)
select c.book_title, cit.reader_name, i.start_date, i.due_date, i.return_date from books c, readers cit, loans i
where c.book_id = i.book_id 
and cit.reader_id = i.reader_id
order by i.start_date;

-- 3  All loans not yet returned as of today. The current day is obtained with sysdate.
select c.book_title, cit.reader_name, i.start_date, i.due_date from books c,  readers cit, loans i
where c.book_id = i.book_id 
and cit.reader_id = i.reader_id
and i.return_date is null
order by i.due_date;

-- 4  All loans not yet returned as of today, plus days since borrowed and overdue days.
select c.book_title, cit.reader_name, i.start_date, i.due_date, trunc(sysdate - i.start_date) as days_since_borrowed, greatest(trunc(sysdate - i.due_date),0) as overdue_days from books c,  readers cit, loans i
where c.book_id = i.book_id 
and cit.reader_id = i.reader_id
and i.return_date is null

-- 5  All loans older than 2 weeks
select book_title, reader_name, start_date, due_date, return_date from books c, readers ci, loans i
where c.book_id = i.book_id
and ci.reader_id = i.reader_id
and ((return_date is not null and return_date < sysdate - 14) or (due_date < sysdate - 14))
order by return_date;

-- 6  Number of books due in the next week: show date and number of books to return.
select trunc(due_date) as return_date, count(*) as books_due_count from loans
    where due_date between sysdate and sysdate + 7
    and return_date is null            
    group by trunc(due_date)                          
    order by trunc(due_date);
	
-- 7  All books physically available in the library (not currently loaned). This includes books never loaned and books returned by today. The query must also handle books loaned multiple times.
select books.book_title from books
    where not exists (
    select 1 from loans
    where books.book_id = loans.book_id
    and loans.return_date is null)
    order by books.book_title;
	
-- 8  All loans for a given reader
select books.book_title, readers.reader_name, loans.start_date, loans.due_date, loans.return_date,loans.notes from books, readers, loans
    where books.book_id = loans.book_id 
    and readers.reader_id = loans.reader_id
    and readers.reader_id = 2 -- set the reader ID for which you want to see loans
    order by loans.loan_id;
	
-- 9  All overdue loans for a given reader (return_date > due_date OR return_date IS NULL and sysdate > due_date)
select books.book_title, loans.start_date, loans.due_date, loans.return_date, loans.notes from books, loans
   where books.book_id = loans.book_id
   and loans.reader_id = 5
   and (loans.return_date is null and sysdate > loans.due_date
   or loans.return_date > loans.due_date)
   order by loans.start_date;
   
-- 10 Readers with more than one active loan today: reader name, book title, start_date, end_date
select readers.reader_name, books.book_title, loans.start_date, loans.due_date from readers, books, loans
   where readers.reader_id = loans.reader_id
   and books.book_id = loans.book_id
   and loans.start_date <= sysdate
   and loans.due_date >= sysdate
   and loans.reader_id in (
    select reader_id
    from loans
    where start_date <= sysdate
    and due_date >= sysdate
    group by reader_id
    having count(*) > 1
)
order by readers.reader_name, loans.start_date;

-- 11 Reader names and the total number of loans made over time: reader_name, loan_count
select readers.reader_name, count(loans.loan_id) as loan_count from readers, loans
   where readers.reader_id = loans.reader_id
   group by readers.reader_name
   order by loan_count desc;
   
-- 12 Top 3 readers by number of loans
select readers.reader_name, count(loans.loan_id) as loan_count from readers, loans
   where readers.reader_id = loans.reader_id
   group by readers.reader_name
   order by loan_count desc
   fetch first 3 rows only;
   
-- 13 Top 3 readers with the most late returns
select readers.reader_name, sum(loans.return_date - loans.due_date) as total_late_days
from readers, loans
where readers.reader_id = loans.reader_id
and loans.return_date > loans.due_date
group by readers.reader_name
order by total_late_days desc
fetch first 3 rows only;

-- 14 Top 3 readers with the worst ratings. A rating is based on the ratio between number of borrowed books and number of late returns.
select 
    readers.reader_name, 
    count(loans.loan_id) as loan_count,
    sum(case when loans.return_date > loans.due_date then 1 else 0 end) as late_return_count,
    case 
        when sum(case when loans.return_date > loans.due_date then 1 else 0 end) > 0 
        then count(loans.loan_id) / sum(case when loans.return_date > loans.due_date then 1 else 0 end) 
        else 0 
    end as rating
from readers, loans
where readers.reader_id = loans.reader_id
group by readers.reader_name
having count(loans.loan_id) > 0 
order by rating desc
fetch first 3 rows with ties;

-- 15 Most requested books for borrowing (highest number of loans)
select 
    books.book_title, 
    count(loans.loan_id) as loan_count
from books, loans
where books.book_id = loans.book_id
group by books.book_title
order by loan_count desc;

-- 16 Most-read authors (authors whose books were requested most often)
select 
    authors.author_name, 
    count(loans.loan_id) as loan_count
from authors, books, loans
where books.primary_author_id = authors.author_id
and books.book_id = loans.book_id
group by authors.author_name
order by loan_count desc;



-- UPDATE
-- 1 Write UPDATE statements that modify an author name and a book title.
update authors
   set author_name = 'Neil Gaiman'
   where author_id = 1;
update books
   set book_title = 'Good Omens'
   where book_id = 1;
   
-- 2 Write an UPDATE statement to move all loans from one reader to another.
update loans
set reader_id = 1  -- New reader ID
where reader_id = 3;  -- Old reader ID whose loans must be updated

-- 3 Fill the current date in the return_date field in loans for a given reader and book (book was returned).
update loans
set return_date = sysdate
where reader_id = 1
and book_id = 3
and return_date is null;

-- 4 Extend the loan period by 3 weeks for all books in the science domain.
update loans i
set i.due_date = i.due_date + 21  
where i.book_id IN (
    select c.book_id
    from books c
    where c.category = 'Science' 
);

-- 5 Convert all book titles to uppercase
update books
set book_title = upper(book_title);

-- 6 Titles of books written by a specific primary author should be init-capitalized (use :primary_author_id)
update books
set book_title = initcap(book_title)
where primary_author_id = :primary_author_id;



-- Write DELETE statements to remove the following information:
-- 1 Loans for a specific reader
delete from loans
where reader_id = 1;

-- 2 A reader from the database. Use 2 methods:
-- Delete all data in child tables related to the readers table (e.g., loans), then delete the parent row.
-- Otherwise, deleting from the parent table causes a foreign key constraint error.
delete from loans
where reader_id = 1;
delete from readers
where reader_id = 1;
-- Execute delete with ON DELETE CASCADE: all child-table rows linked by foreign keys are removed automatically.
ALTER TABLE loans ADD CONSTRAINT fk_loans_readers FOREIGN KEY (reader_id) REFERENCES readers (reader_id) ON DELETE CASCADE;
delete from readers
where reader_id = 1;





-- Write PL/SQL functions to solve the following tasks:

-- 1 Check whether a book is available or borrowed: return 0 if available, 1 if borrowed:

--CREATE OR REPLACE 
--FUNCTION book_available(book_title in varchar2) return number is
--begin
--	…
--return …;
--end;
--/

create or replace function book_available (p_book_id in number)
return number
is
    v_count number;
begin
    select count(*)
    into v_count
    from loans
    where book_id = p_book_id
      and return_date is null;

    if v_count > 0 then
        return 1; 
    else
        return 0;
    end if;
end book_available;
/

select book_available(9) as one_if_borrowed from dual;


-- 2 Calculate the number of books for a given author

--create or replace 
--function book_count_per_author(author_name in varchar2) return number is
--begin
    -- your logic here
--    return ...;
--end;
--/

create or replace 
function book_count_per_author(author_id in number) 
return number 
is
    v_count number := 0;
begin
    select count(c.book_id)
    into v_count
    from books c
    where (c.primary_author_id = author_id and c.primary_author_id is not null)
       or (c.secondary_author_id = author_id and c.primary_author_id is not null) 
       or (c.tertiary_author_id = author_id and c.primary_author_id is not null);

    return v_count;
end;
/
select book_count_per_author(9) from dual;




-- TRIGGERS
-- 1 Write the example trigger and verify behavior when inserting a new row in loans.

drop sequence loan_id; 
drop trigger trig_loans;

create sequence loan_id
  increment by 1
  start with 1
  minvalue 1
  maxvalue 9999999999999;


create or replace trigger trig_loans
  before insert on loans
  referencing new as new old as old
  for each row
begin
  select loan_id.nextval into :new.loan_id from dual;
end;
/

delete from loans;
insert into loans (book_id, reader_id, start_date, due_date, return_date, notes) values (1, 1, sysdate - 4, sysdate + 6, null, 'notes');
select * from loans;


-- 2 Based on the model, write a trigger that auto-fills book_id when inserting a row into books.

drop sequence book_id;  
drop trigger before_insert_books;

create sequence book_id
  increment by 1
  start with 13
  minvalue 1
  maxvalue 9999999999999;
  
create or replace trigger before_insert_books
  before insert on books
  for each row
begin
  select book_id.nextval into :new.book_id from dual;
end;
/

delete from books;
insert into books (category, book_title, primary_author_id, secondary_author_id, tertiary_author_id) values ('Fiction', 'Test Book', 1, null, null);
select * from books;


-- 3 Write a trigger that auto-fills start_date and due_date for a new loan (start_date = sysdate, due_date = start_date + 3 weeks)

create or replace trigger before_insert_loans
  before insert on loans
  for each row
begin
  -- set start_date to current date
  :new.start_date := sysdate;

  -- set due_date to 3 weeks after start_date
  :new.due_date := sysdate + 21; -- 21 days = 3 weeks
end;
/

delete from loans;
insert into loans values(1, 1, 1, null, null, null, null);
select * from loans;









    
