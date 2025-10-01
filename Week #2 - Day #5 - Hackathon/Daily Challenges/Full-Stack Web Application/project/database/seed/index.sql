-- Schema for Library Management
CREATE TABLE authors (
  author_id SERIAL PRIMARY KEY,
  name VARCHAR(120) NOT NULL
);

CREATE TABLE books (
  book_id SERIAL PRIMARY KEY,
  title VARCHAR(120) NOT NULL,
  year INTEGER
);

CREATE TABLE books_authors (
  book_id INTEGER NOT NULL REFERENCES books(book_id) ON DELETE CASCADE,
  author_id INTEGER NOT NULL REFERENCES authors(author_id) ON DELETE CASCADE,
  PRIMARY KEY (book_id, author_id)
);

-- Seed authors (10)
INSERT INTO authors (name) VALUES ('Jane Austen');
INSERT INTO authors (name) VALUES ('Mark Twain');
INSERT INTO authors (name) VALUES ('George Orwell');
INSERT INTO authors (name) VALUES ('J.K. Rowling');
INSERT INTO authors (name) VALUES ('J.R.R. Tolkien');
INSERT INTO authors (name) VALUES ('Agatha Christie');
INSERT INTO authors (name) VALUES ('Ernest Hemingway');
INSERT INTO authors (name) VALUES ('F. Scott Fitzgerald');
INSERT INTO authors (name) VALUES ('Mary Shelley');
INSERT INTO authors (name) VALUES ('Arthur Conan Doyle');

-- Seed books (10)
INSERT INTO books (title, year) VALUES ('Pride and Prejudice', 1813);
INSERT INTO books (title, year) VALUES ('Adventures of Huckleberry Finn', 1884);
INSERT INTO books (title, year) VALUES ('1984', 1949);
INSERT INTO books (title, year) VALUES ('Harry Potter and the Philosopher''s Stone', 1997);
INSERT INTO books (title, year) VALUES ('The Hobbit', 1937);
INSERT INTO books (title, year) VALUES ('Murder on the Orient Express', 1934);
INSERT INTO books (title, year) VALUES ('The Old Man and the Sea', 1952);
INSERT INTO books (title, year) VALUES ('The Great Gatsby', 1925);
INSERT INTO books (title, year) VALUES ('Frankenstein', 1818);
INSERT INTO books (title, year) VALUES ('A Study in Scarlet', 1887);

-- Seed relations
INSERT INTO books_authors (book_id, author_id)
SELECT b.book_id, a.author_id
FROM books b JOIN authors a ON a.name='Jane Austen'
WHERE b.title='Pride and Prejudice'
AND NOT EXISTS (
  SELECT 1 FROM books_authors x WHERE x.book_id = b.book_id AND x.author_id = a.author_id
);
INSERT INTO books_authors (book_id, author_id)
SELECT b.book_id, a.author_id
FROM books b JOIN authors a ON a.name='Mark Twain'
WHERE b.title='Adventures of Huckleberry Finn'
AND NOT EXISTS (
  SELECT 1 FROM books_authors x WHERE x.book_id = b.book_id AND x.author_id = a.author_id
);
INSERT INTO books_authors (book_id, author_id)
SELECT b.book_id, a.author_id
FROM books b JOIN authors a ON a.name='George Orwell'
WHERE b.title='1984'
AND NOT EXISTS (
  SELECT 1 FROM books_authors x WHERE x.book_id = b.book_id AND x.author_id = a.author_id
);
INSERT INTO books_authors (book_id, author_id)
SELECT b.book_id, a.author_id
FROM books b JOIN authors a ON a.name='J.K. Rowling'
WHERE b.title='Harry Potter and the Philosopher''s Stone'
AND NOT EXISTS (
  SELECT 1 FROM books_authors x WHERE x.book_id = b.book_id AND x.author_id = a.author_id
);
INSERT INTO books_authors (book_id, author_id)
SELECT b.book_id, a.author_id
FROM books b JOIN authors a ON a.name='J.R.R. Tolkien'
WHERE b.title='The Hobbit'
AND NOT EXISTS (
  SELECT 1 FROM books_authors x WHERE x.book_id = b.book_id AND x.author_id = a.author_id
);
INSERT INTO books_authors (book_id, author_id)
SELECT b.book_id, a.author_id
FROM books b JOIN authors a ON a.name='Agatha Christie'
WHERE b.title='Murder on the Orient Express'
AND NOT EXISTS (
  SELECT 1 FROM books_authors x WHERE x.book_id = b.book_id AND x.author_id = a.author_id
);
INSERT INTO books_authors (book_id, author_id)
SELECT b.book_id, a.author_id
FROM books b JOIN authors a ON a.name='Ernest Hemingway'
WHERE b.title='The Old Man and the Sea'
AND NOT EXISTS (
  SELECT 1 FROM books_authors x WHERE x.book_id = b.book_id AND x.author_id = a.author_id
);
INSERT INTO books_authors (book_id, author_id)
SELECT b.book_id, a.author_id
FROM books b JOIN authors a ON a.name='F. Scott Fitzgerald'
WHERE b.title='The Great Gatsby'
AND NOT EXISTS (
  SELECT 1 FROM books_authors x WHERE x.book_id = b.book_id AND x.author_id = a.author_id
);
INSERT INTO books_authors (book_id, author_id)
SELECT b.book_id, a.author_id
FROM books b JOIN authors a ON a.name='Mary Shelley'
WHERE b.title='Frankenstein'
AND NOT EXISTS (
  SELECT 1 FROM books_authors x WHERE x.book_id = b.book_id AND x.author_id = a.author_id
);
INSERT INTO books_authors (book_id, author_id)
SELECT b.book_id, a.author_id
FROM books b JOIN authors a ON a.name='Arthur Conan Doyle'
WHERE b.title='A Study in Scarlet'
AND NOT EXISTS (
  SELECT 1 FROM books_authors x WHERE x.book_id = b.book_id AND x.author_id = a.author_id
);
