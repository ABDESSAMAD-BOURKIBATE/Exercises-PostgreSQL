CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL
);

CREATE TABLE product_orders (
  order_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(user_id),
  order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE items (
  item_id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES product_orders(order_id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  price NUMERIC(10,2) NOT NULL
);

-- Order total for a given order (example below computes for the first order)
-- and user-specific order total (example below for Alice's first order)

INSERT INTO users (first_name, last_name) VALUES ('Alice','Smith');
INSERT INTO users (first_name, last_name) VALUES ('Bob','Jones');

INSERT INTO product_orders (user_id) VALUES ((SELECT user_id FROM users WHERE first_name = 'Alice' AND last_name = 'Smith' LIMIT 1));
INSERT INTO product_orders (user_id) VALUES ((SELECT user_id FROM users WHERE first_name = 'Bob' AND last_name = 'Jones' LIMIT 1));

INSERT INTO items (order_id, name, price)
VALUES ((SELECT order_id FROM product_orders ORDER BY order_id LIMIT 1), 'Pen', 1.50);
INSERT INTO items (order_id, name, price)
VALUES ((SELECT order_id FROM product_orders ORDER BY order_id LIMIT 1), 'Notebook', 3.25);
INSERT INTO items (order_id, name, price)
VALUES ((
  SELECT order_id FROM (
    SELECT order_id, ROW_NUMBER() OVER (ORDER BY order_id) AS rn
    FROM product_orders
  ) t WHERE rn = 2
), 'Mug', 5.99);

SELECT COALESCE(SUM(price), 0.00) AS alice_order_total
FROM items
WHERE order_id = (SELECT order_id FROM product_orders ORDER BY order_id LIMIT 1);

SELECT COALESCE(SUM(i.price), 0.00) AS alice_user_order_total
FROM product_orders o
JOIN items i ON i.order_id = o.order_id
WHERE o.user_id = (SELECT user_id FROM users WHERE first_name = 'Alice' AND last_name = 'Smith' LIMIT 1)
  AND o.order_id = (SELECT order_id FROM product_orders ORDER BY order_id LIMIT 1);