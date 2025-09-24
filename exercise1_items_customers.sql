CREATE DATABASE public;
\c public;

CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price NUMERIC(10,2) NOT NULL
);

CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL
);

INSERT INTO items (name, price) VALUES
  ('Small Desk', 100),
  ('Large Desk', 300),
  ('Fan', 80);


INSERT INTO customers (first_name, last_name) VALUES
  ('Greg','Jones'),
  ('Sandra','Jones'),
  ('Scott','Scott'),
  ('Trevor','Green'),
  ('Melanie','Johnson');

SELECT * FROM items;

SELECT * FROM items WHERE price > 80;

SELECT * FROM items WHERE price <= 300;

SELECT * FROM customers WHERE last_name = 'Smith';

SELECT * FROM customers WHERE last_name = 'Jones';

SELECT * FROM customers WHERE first_name <> 'Scott';
