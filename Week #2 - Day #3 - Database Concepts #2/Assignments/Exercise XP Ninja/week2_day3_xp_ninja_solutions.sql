SELECT f.film_id, f.title
FROM film f
WHERE f.rating IN ('G','PG')
  AND NOT EXISTS (
    SELECT 1
    FROM inventory i
    JOIN rental r ON r.inventory_id = i.inventory_id AND r.return_date IS NULL
    WHERE i.film_id = f.film_id
  )
ORDER BY f.title;

CREATE TABLE kids_waitlist (
  wait_id SERIAL PRIMARY KEY,
  film_id INTEGER NOT NULL REFERENCES film(film_id),
  child_name VARCHAR(100) NOT NULL,
  requested_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO kids_waitlist (film_id, child_name)
SELECT f.film_id, 'Alice'
FROM film f
WHERE f.rating IN ('G','PG')
ORDER BY f.title
LIMIT 1;

INSERT INTO kids_waitlist (film_id, child_name)
SELECT film_id, 'Bob'
FROM (
  SELECT f.film_id, ROW_NUMBER() OVER (ORDER BY f.title) AS rn
  FROM film f
  WHERE f.rating IN ('G','PG')
) t
WHERE rn = 2;

SELECT wl.film_id, f.title, COUNT(*) AS waiting_count
FROM kids_waitlist wl
JOIN film f ON f.film_id = wl.film_id
GROUP BY wl.film_id, f.title
ORDER BY f.title;