-- CREATE TABLES AND CONSTRAINTS

-- 1. Authors
CREATE TABLE authors
    (author_id                       NUMBER NOT NULL,
    author_name                     VARCHAR2(50) NOT NULL
    );
ALTER TABLE authors ADD CONSTRAINT pk_author PRIMARY KEY (author_id);
ALTER TABLE authors ADD CONSTRAINT uk_author_name UNIQUE (author_name);

-- 2. Readers
CREATE TABLE readers
    (reader_id                     NUMBER NOT NULL,
    reader_name                   VARCHAR2(50),
    age                         NUMBER(2,0),
    sex                            VARCHAR2(1),
    rating                    VARCHAR2(50));  
ALTER TABLE readers ADD CONSTRAINT pk_reader PRIMARY KEY (reader_id);

-- 3. Books
CREATE TABLE books
    (book_id                       NUMBER NOT NULL,
    category                        VARCHAR2(50),
    book_title                    VARCHAR2(100) NOT NULL,
    primary_author_id                      NUMBER,
    secondary_author_id                      NUMBER,
    tertiary_author_id                      NUMBER);
    ALTER TABLE books ADD CONSTRAINT pk_book PRIMARY KEY (book_id);
    ALTER TABLE books ADD CONSTRAINT ck_books_category CHECK (category in ('Fiction','Science','Entertainment'));
    ALTER TABLE books ADD CONSTRAINT uk_book_title UNIQUE (book_title);
    ALTER TABLE books ADD CONSTRAINT fk_books_authors FOREIGN KEY (primary_author_id) REFERENCES authors (author_id);

-- 4. Loans
    CREATE TABLE loans
    (loan_id                    NUMBER NOT NULL,
    book_id                       NUMBER NOT NULL,
    reader_id                     NUMBER NOT NULL,
    start_date                     DATE NOT NULL,
    due_date                       DATE NOT NULL,
    return_date                    DATE,
    notes                     VARCHAR2(50));
    ALTER TABLE loans ADD CONSTRAINT pk_loan PRIMARY KEY (loan_id);
    ALTER TABLE loans ADD CONSTRAINT fk_loans_books FOREIGN KEY (book_id) REFERENCES books (book_id);
    ALTER TABLE loans ADD CONSTRAINT fk_loans_readers FOREIGN KEY (reader_id) REFERENCES readers (reader_id);




-- INSERT SAMPLE DATA

-- 1. Authors
    insert into authors values(1, 'Neil Gaiman');
    insert into authors values(2, 'Terry Pratchett');
    insert into authors values(3, 'Stephen Hawking');
    insert into authors values(4, 'Leonard Mlodinow');
    insert into authors values(5, 'Siddhartha Mukherjee');
    insert into authors values(6, 'Michio Kaku');
    insert into authors values(7, 'David Trottier');
    insert into authors values(8, 'Douglas Adams');
    insert into authors values(9, 'Tina Fey');
    
-- 2. Readers
    insert into readers values(1, 'Dăscălescu Mihai', 22,'M','FB');
    insert into readers values(2, 'Vornicu Irina-Maria', 36,'F','S');
    insert into readers values(3, 'Dinescu Călin', 70,'M','NS');
    insert into readers values(4, 'Popescu Lia-Ioana', 21,'F','B');
    insert into readers values(5, 'Mihăiescu Cezarina', 25,'F','S');
    
-- 3. Books
    insert into books values(1,'Fiction','Good Omens',1,2,null);
    insert into books values(2,'Fiction','The Ocean at the End of the Lane',1,null,null);
    insert into books values(3,'Fiction','American Gods',1,null,null);
    insert into books values(4,'Fiction','The Colour of Magic',2,null,null);
    insert into books values(5,'Science','The Grand Design',3,4,null);
    insert into books values(6,'Science','A Briefer History of Time',3,4,null);
    insert into books values(7,'Science','The Gene: An Intimate History',5,null,null);
    insert into books values(8,'Science','Physics of the Impossible',6,null,null);
    insert into books values(9,'Entertainment','Two Screenplays',7,null,null);
    insert into books values(10,'Entertainment','Last Chance to See',8,null,null);
    insert into books values(11,'Entertainment','The Meaning of Liff',8,null,null);
    insert into books values(12,'Entertainment','Bossypants',9,null,null);
    
-- 4. Loans
    insert into loans values(1, 1, 1, sysdate-4,sysdate+6, sysdate-2,null);
    insert into loans values(2, 2, 3, sysdate-10,sysdate, sysdate-5,'dirty cover');
    insert into loans values(3, 2, 4, sysdate-2,sysdate+8, sysdate,null);
    insert into loans values(4, 4, 5, sysdate,sysdate+10, null,null);
    insert into loans values(5, 6, 2, sysdate-20,sysdate-10, sysdate-15,'pen marks');
    insert into loans values(6, 10, 3, sysdate-25,sysdate-15, sysdate-10,'torn page, returned 5 days late');
    insert into loans values(7, 11, 1, sysdate-15,sysdate-5, sysdate-2,'returned 3 days late');
    insert into loans values(8, 12, 2, sysdate-4,sysdate+6, null,null);
    insert into loans values(9, 9, 4, sysdate-30,sysdate-20, sysdate-16,'returned 4 days late');
    insert into loans values(10, 8, 5, sysdate,sysdate+10, null,null);
    insert into loans values(11, 6, 3, sysdate-20,sysdate-10, sysdate-2,'returned 8 days late');