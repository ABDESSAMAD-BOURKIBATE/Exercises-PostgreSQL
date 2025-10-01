WITH ranked AS (
  SELECT firstname, lastname,
         ROW_NUMBER() OVER (ORDER BY firstname ASC, lastname ASC) AS rn,
         COUNT(*) OVER () AS cnt
  FROM customers
)
SELECT firstname, lastname
FROM ranked
WHERE rn > cnt - 2
ORDER BY firstname ASC, lastname ASC;

DELETE FROM purchases
WHERE customer_id IN (
  SELECT id FROM customers WHERE firstname = 'Scott' AND lastname = 'Scott'
);

SELECT * FROM customers
WHERE firstname = 'Scott' AND lastname = 'Scott';

SELECT p.id, p.customer_id, p.item_id, p.quantity_purchased,
       COALESCE(c.firstname, '') AS firstname,
       COALESCE(c.lastname, '')  AS lastname
FROM purchases p
LEFT JOIN customers c ON c.id = p.customer_id
ORDER BY p.id;

SELECT p.id, p.customer_id, p.item_id, p.quantity_purchased,
       c.firstname, c.lastname
FROM purchases p
INNER JOIN customers c ON c.id = p.customer_id
ORDER BY p.id;