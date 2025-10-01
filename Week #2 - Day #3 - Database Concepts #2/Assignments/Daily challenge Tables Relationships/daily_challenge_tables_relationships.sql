CREATE TABLE customer (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50) NOT NULL
);

CREATE TABLE customer_profile (
  id SERIAL PRIMARY KEY,
  isloggedin BOOLEAN NOT NULL DEFAULT FALSE,
  customer_id INTEGER NOT NULL UNIQUE REFERENCES customer(id)
);

INSERT INTO customer (first_name, last_name) VALUES ('John','Doe');
INSERT INTO customer (first_name, last_name) VALUES ('Jerome','Lalu');
INSERT INTO customer (first_name, last_name) VALUES ('Lea','Rive');

INSERT INTO customer_profile (isloggedin, customer_id)
SELECT TRUE, c.id FROM customer c WHERE c.first_name = 'John' AND c.last_name = 'Doe' LIMIT 1;

INSERT INTO customer_profile (isloggedin, customer_id)
SELECT FALSE, c.id FROM customer c WHERE c.first_name = 'Jerome' AND c.last_name = 'Lalu' LIMIT 1;

SELECT c.first_name
FROM customer c
JOIN customer_profile p ON p.customer_id = c.id
WHERE p.isloggedin = TRUE;

SELECT c.first_name, p.isloggedin
FROM customer c
LEFT JOIN customer_profile p ON p.customer_id = c.id
ORDER BY c.first_name;

SELECT COUNT(*) AS not_logged_in
FROM customer c
LEFT JOIN customer_profile p ON p.customer_id = c.id
WHERE COALESCE(p.isloggedin, FALSE) = FALSE;

CREATE TABLE book (
  book_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255) NOT NULL
);

INSERT INTO book (title, author) VALUES ('Alice In Wonderland','Lewis Carroll');
INSERT INTO book (title, author) VALUES ('Harry Potter','J.K Rowling');
INSERT INTO book (title, author) VALUES ('To kill a mockingbird','Harper Lee');

CREATE TABLE student (
  student_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  age INTEGER CHECK (age <= 15)
);

INSERT INTO student (name, age) VALUES ('John',12);
INSERT INTO student (name, age) VALUES ('Lera',11);
INSERT INTO student (name, age) VALUES ('Patrick',10);
INSERT INTO student (name, age) VALUES ('Bob',14);

CREATE TABLE library (
  book_fk_id INTEGER NOT NULL REFERENCES book(book_id) ON DELETE CASCADE,
  student_fk_id INTEGER NOT NULL REFERENCES student(student_id) ON DELETE CASCADE,
  borrowed_date DATE NOT NULL,
  PRIMARY KEY (book_fk_id, student_fk_id)
);

INSERT INTO library (book_fk_id, student_fk_id, borrowed_date)
VALUES (
  (SELECT b.book_id FROM book b WHERE b.title = 'Alice In Wonderland' LIMIT 1),
  (SELECT s.student_id FROM student s WHERE s.name = 'John' LIMIT 1),
  DATE '2022-02-15'
);

INSERT INTO library (book_fk_id, student_fk_id, borrowed_date)
VALUES (
  (SELECT b.book_id FROM book b WHERE b.title = 'To kill a mockingbird' LIMIT 1),
  (SELECT s.student_id FROM student s WHERE s.name = 'Bob' LIMIT 1),
  DATE '2021-03-03'
);

INSERT INTO library (book_fk_id, student_fk_id, borrowed_date)
VALUES (
  (SELECT b.book_id FROM book b WHERE b.title = 'Alice In Wonderland' LIMIT 1),
  (SELECT s.student_id FROM student s WHERE s.name = 'Lera' LIMIT 1),
  DATE '2021-05-23'
);

INSERT INTO library (book_fk_id, student_fk_id, borrowed_date)
VALUES (
  (SELECT b.book_id FROM book b WHERE b.title = 'Harry Potter' LIMIT 1),
  (SELECT s.student_id FROM student s WHERE s.name = 'Bob' LIMIT 1),
  DATE '2021-08-12'
);

SELECT * FROM library;

SELECT s.name, b.title
FROM library l
JOIN student s ON s.student_id = l.student_fk_id
JOIN book b ON b.book_id = l.book_fk_id
ORDER BY s.name, b.title;

SELECT AVG(s.age) AS avg_age
FROM library l
JOIN student s ON s.student_id = l.student_fk_id
JOIN book b ON b.book_id = l.book_fk_id
WHERE b.title = 'Alice In Wonderland';

DELETE FROM student WHERE name = 'Bob';

SELECT * FROM library;