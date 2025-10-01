SELECT * FROM items ORDER BY price ASC;

SELECT * FROM items WHERE price >= 80 ORDER BY price DESC;

SELECT firstname, lastname FROM customers ORDER BY firstname ASC LIMIT 3;

SELECT lastname FROM customers ORDER BY lastname DESC;

SELECT * FROM customer;

SELECT (first_name || ' ' || last_name) AS full_name FROM customer;

SELECT DISTINCT create_date FROM customer ORDER BY create_date;

SELECT * FROM customer ORDER BY first_name DESC;

SELECT film_id, title, description, release_year, rental_rate FROM film ORDER BY rental_rate ASC, film_id ASC;

SELECT a.address, a.phone FROM address a JOIN customer c ON c.address_id = a.address_id WHERE a.district = 'Texas';

SELECT * FROM film WHERE film_id IN (15, 150);

SELECT film_id, title, description, length, rental_rate FROM film WHERE title = 'ACADEMY DINOSAUR';

SELECT film_id, title, description, length, rental_rate FROM film WHERE LOWER(title) LIKE 'ac%';

SELECT film_id, title, rental_rate FROM film ORDER BY rental_rate ASC, film_id ASC LIMIT 10;

WITH ranked_films AS (
  SELECT film_id, title, rental_rate, ROW_NUMBER() OVER (ORDER BY rental_rate ASC, film_id ASC) AS rn
  FROM film
)
SELECT film_id, title, rental_rate FROM ranked_films WHERE rn BETWEEN 11 AND 20;

SELECT c.first_name, c.last_name, p.amount, p.payment_date
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
ORDER BY c.customer_id, p.payment_date;

SELECT f.*
FROM film f
LEFT JOIN inventory i ON i.film_id = f.film_id
WHERE i.film_id IS NULL;

SELECT ci.city, co.country
FROM city ci
JOIN country co ON co.country_id = ci.country_id
ORDER BY co.country, ci.city;

SELECT c.customer_id, c.first_name, c.last_name, p.amount, p.payment_date
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
ORDER BY p.staff_id, c.customer_id, p.payment_date;