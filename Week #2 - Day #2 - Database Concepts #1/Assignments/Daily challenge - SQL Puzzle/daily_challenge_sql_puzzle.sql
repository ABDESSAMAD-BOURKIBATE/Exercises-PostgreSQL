CREATE TABLE FirstTab (
     id integer, 
     name VARCHAR(10)
);

INSERT INTO FirstTab (id, name) VALUES (5,'Pawan');
INSERT INTO FirstTab (id, name) VALUES (6,'Sharlee');
INSERT INTO FirstTab (id, name) VALUES (7,'Krish');
INSERT INTO FirstTab (id, name) VALUES (NULL,'Avtaar');

SELECT * FROM FirstTab;

CREATE TABLE SecondTab (
    id integer 
);

INSERT INTO SecondTab (id) VALUES (5);
INSERT INTO SecondTab (id) VALUES (NULL);

SELECT * FROM SecondTab;

-- Expected vs Actual Outputs

-- Q1
SELECT 'Q1' AS q, 'expected' AS kind, 0 AS cnt FROM FirstTab LIMIT 1;
SELECT 'Q1' AS q, 'actual'   AS kind,
       COUNT(*) AS cnt
FROM FirstTab AS ft
WHERE ft.id NOT IN ( SELECT id FROM SecondTab WHERE id IS NULL );

-- Q2
SELECT 'Q2' AS q, 'expected' AS kind, 2 AS cnt FROM FirstTab LIMIT 1;
SELECT 'Q2' AS q, 'actual'   AS kind,
       COUNT(*) AS cnt
FROM FirstTab AS ft
WHERE ft.id NOT IN ( SELECT id FROM SecondTab WHERE id = 5 );

-- Q3
SELECT 'Q3' AS q, 'expected' AS kind, 0 AS cnt FROM FirstTab LIMIT 1;
SELECT 'Q3' AS q, 'actual'   AS kind,
       COUNT(*) AS cnt
FROM FirstTab AS ft
WHERE ft.id NOT IN ( SELECT id FROM SecondTab );

-- Q4
SELECT 'Q4' AS q, 'expected' AS kind, 2 AS cnt FROM FirstTab LIMIT 1;
SELECT 'Q4' AS q, 'actual'   AS kind,
       COUNT(*) AS cnt
FROM FirstTab AS ft
WHERE ft.id NOT IN ( SELECT id FROM SecondTab WHERE id IS NOT NULL );