SELECT r.rental_id, f.film_id, f.title, r.rental_date, r.return_date
FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE r.return_date IS NULL
ORDER BY r.rental_date;

SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS outstanding_count
FROM rental r
JOIN customer c ON c.customer_id = r.customer_id
WHERE r.return_date IS NULL
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY outstanding_count DESC, c.customer_id;

SELECT DISTINCT f.film_id, f.title
FROM film f
JOIN film_actor fa ON fa.film_id = f.film_id
JOIN actor a ON a.actor_id = fa.actor_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE a.first_name = 'JOE' AND a.last_name = 'SWANK'
  AND c.name = 'Action'
ORDER BY f.title;

SELECT COUNT(*) AS store_count FROM store;

SELECT s.store_id, ci.city, co.country
FROM store s
JOIN address a ON a.address_id = s.address_id
JOIN city ci ON ci.city_id = a.city_id
JOIN country co ON co.country_id = ci.country_id
ORDER BY s.store_id;

WITH available_inventory AS (
  SELECT i.inventory_id, i.store_id, i.film_id
  FROM inventory i
  WHERE NOT EXISTS (
    SELECT 1 FROM rental r WHERE r.inventory_id = i.inventory_id AND r.return_date IS NULL
  )
)
SELECT ai.store_id,
       SUM(f.length) AS total_minutes,
       SUM(f.length)/60.0 AS total_hours,
       SUM(f.length)/(60.0*24.0) AS total_days
FROM available_inventory ai
JOIN film f ON f.film_id = ai.film_id
GROUP BY ai.store_id
ORDER BY ai.store_id;

SELECT DISTINCT c.customer_id, c.first_name, c.last_name, ci.city
FROM customer c
JOIN address ca ON ca.address_id = c.address_id
JOIN city ci ON ci.city_id = ca.city_id
WHERE ci.city_id IN (
  SELECT ci2.city_id
  FROM store s
  JOIN address a ON a.address_id = s.address_id
  JOIN city ci2 ON ci2.city_id = a.city_id
)
ORDER BY ci.city, c.last_name, c.first_name;

SELECT DISTINCT c.customer_id, c.first_name, c.last_name, co.country
FROM customer c
JOIN address ca ON ca.address_id = c.address_id
JOIN city ci ON ci.city_id = ca.city_id
JOIN country co ON co.country_id = ci.country_id
WHERE co.country_id IN (
  SELECT co2.country_id
  FROM store s
  JOIN address a ON a.address_id = s.address_id
  JOIN city ci2 ON ci2.city_id = a.city_id
  JOIN country co2 ON co2.country_id = ci2.country_id
)
ORDER BY co.country, c.last_name, c.first_name;

WITH safe_films AS (
  SELECT f.film_id, f.title, f.description, f.length
  FROM film f
  WHERE f.film_id NOT IN (
    SELECT fc.film_id
    FROM film_category fc
    JOIN category c ON c.category_id = fc.category_id
    WHERE c.name = 'Horror'
  )
  AND NOT (
    LOWER(f.title) LIKE '%beast%' OR LOWER(f.description) LIKE '%beast%' OR
    LOWER(f.title) LIKE '%monster%' OR LOWER(f.description) LIKE '%monster%' OR
    LOWER(f.title) LIKE '%ghost%' OR LOWER(f.description) LIKE '%ghost%' OR
    LOWER(f.title) LIKE '%dead%' OR LOWER(f.description) LIKE '%dead%' OR
    LOWER(f.title) LIKE '%zombie%' OR LOWER(f.description) LIKE '%zombie%' OR
    LOWER(f.title) LIKE '%undead%' OR LOWER(f.description) LIKE '%undead%'
  )
),
available_inventory AS (
  SELECT i.inventory_id, i.store_id, i.film_id
  FROM inventory i
  WHERE NOT EXISTS (
    SELECT 1 FROM rental r WHERE r.inventory_id = i.inventory_id AND r.return_date IS NULL
  )
)
SELECT ai.store_id,
       SUM(sf.length) AS total_minutes_safe,
       SUM(sf.length)/60.0 AS total_hours_safe,
       SUM(sf.length)/(60.0*24.0) AS total_days_safe
FROM available_inventory ai
JOIN safe_films sf ON sf.film_id = ai.film_id
GROUP BY ai.store_id
ORDER BY ai.store_id;