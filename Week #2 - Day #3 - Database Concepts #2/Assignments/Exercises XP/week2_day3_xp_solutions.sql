SELECT name FROM language ORDER BY name;

SELECT f.title, f.description, l.name AS language
FROM film f
JOIN language l ON l.language_id = f.language_id
ORDER BY f.title;

SELECT f.title, f.description, l.name AS language
FROM language l
LEFT JOIN film f ON f.language_id = l.language_id
ORDER BY l.name, f.title;

CREATE TABLE new_film (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO new_film (name) VALUES ('Sumo Spirit');
INSERT INTO new_film (name) VALUES ('River Boat');
INSERT INTO new_film (name) VALUES ('Quantum Dreams');

CREATE TABLE customer_review (
  review_id SERIAL PRIMARY KEY,
  film_id INTEGER NOT NULL REFERENCES new_film(id) ON DELETE CASCADE,
  language_id SMALLINT NOT NULL REFERENCES language(language_id),
  title VARCHAR(255) NOT NULL,
  score SMALLINT CHECK (score BETWEEN 1 AND 10),
  review_text TEXT,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customer_review (film_id, language_id, title, score, review_text)
VALUES ((SELECT id FROM new_film WHERE name = 'Sumo Spirit' LIMIT 1), 1, 'Great Sumo Tale', 8, 'Fun and inspiring.');
INSERT INTO customer_review (film_id, language_id, title, score, review_text)
VALUES ((SELECT id FROM new_film WHERE name = 'River Boat'   LIMIT 1), 1, 'Boat Drama', 7, 'Nice visuals.');

DELETE FROM new_film WHERE name = 'River Boat';

UPDATE film SET language_id = 2 WHERE film_id IN (1,2,3);

SELECT tc.constraint_name, kcu.column_name, ccu.table_name AS foreign_table_name, ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name AND tc.constraint_schema = kcu.constraint_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name AND ccu.constraint_schema = tc.constraint_schema
WHERE tc.table_name = 'customer' AND tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.constraint_name, kcu.column_name;

DROP TABLE customer_review;

SELECT COUNT(*) AS outstanding_rentals
FROM rental
WHERE return_date IS NULL;

SELECT f.film_id, f.title, f.replacement_cost
FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE r.return_date IS NULL
ORDER BY f.rental_rate DESC, f.replacement_cost DESC
LIMIT 30;

SELECT DISTINCT f.film_id, f.title
FROM film f
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN actor a ON a.actor_id = fa.actor_id
WHERE a.first_name = 'PENELOPE' AND a.last_name = 'MONROE'
  AND (LOWER(f.title) LIKE '%sumo%' OR LOWER(f.description) LIKE '%sumo%');

SELECT f.film_id, f.title
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE f.length < 60 AND f.rating = 'R' AND c.name = 'Documentary';

SELECT DISTINCT f.film_id, f.title
FROM rental r
JOIN payment p ON p.rental_id = r.rental_id
JOIN customer c ON c.customer_id = r.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE c.first_name = 'MATTHEW' AND c.last_name = 'MAHAN'
  AND p.amount > 4.00
  AND r.return_date >= DATE '2005-07-28'
  AND r.return_date <  DATE '2005-08-02';

SELECT DISTINCT f.film_id, f.title
FROM rental r
JOIN customer c ON c.customer_id = r.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE c.first_name = 'MATTHEW' AND c.last_name = 'MAHAN'
  AND (LOWER(f.title) LIKE '%boat%' OR LOWER(f.description) LIKE '%boat%')
ORDER BY f.replacement_cost DESC
LIMIT 1;