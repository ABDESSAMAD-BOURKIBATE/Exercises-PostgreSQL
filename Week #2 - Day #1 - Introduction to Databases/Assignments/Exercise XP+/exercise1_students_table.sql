CREATE DATABASE bootcamp;

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL
);

INSERT INTO students (id, first_name, last_name, birth_date) VALUES
    (1, 'Marc', 'Benichou', '1998-11-02'),
    (2, 'Yoan', 'Cohen', '2010-12-03'),
    (3, 'Lea', 'Benichou', '1987-07-27'),
    (4, 'Amelia', 'Dux', '1996-04-07'),
    (5, 'David', 'Grez', '2003-06-14'),
    (6, 'Omer', 'Simpson', '1980-10-03');

INSERT INTO students (first_name, last_name, birth_date) VALUES
    ('Ahmed', 'Bourkibate', '1995-03-15');

SELECT setval('students_id_seq', (SELECT MAX(id) FROM students));

SELECT * FROM students;

SELECT first_name, last_name FROM students;

SELECT first_name, last_name 
FROM students 
WHERE id = 2;

SELECT first_name, last_name 
FROM students 
WHERE last_name = 'Benichou' AND first_name = 'Marc';

SELECT first_name, last_name 
FROM students 
WHERE last_name = 'Benichou' OR first_name = 'Marc';

SELECT first_name, last_name 
FROM students 
WHERE first_name LIKE '%a%';

SELECT first_name, last_name 
FROM students 
WHERE first_name LIKE 'a%';

SELECT first_name, last_name 
FROM students 
WHERE first_name LIKE '%a';

SELECT first_name, last_name 
FROM students 
WHERE first_name LIKE '%a_';

SELECT first_name, last_name 
FROM students 
WHERE id IN (1, 3);

SELECT * 
FROM students 
WHERE birth_date >= '2000-01-01';

\d students;

SELECT COUNT(*) as total_students FROM students;

SELECT * FROM students ORDER BY birth_date ASC;

SELECT *, 
       EXTRACT(YEAR FROM age(CURRENT_DATE, birth_date)) as age 
FROM students 
ORDER BY birth_date DESC;