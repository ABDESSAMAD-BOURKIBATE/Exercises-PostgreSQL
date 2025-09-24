CREATE TABLE actors (
    actor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    age DATE NOT NULL,
    number_oscars INTEGER
);

INSERT INTO actors (first_name, last_name, age, number_oscars) VALUES
('Matt', 'Damon', '1970-10-08', 5),
('George', 'Clooney', '1961-05-06', 2),
('Jennifer', 'Lawrence', '1990-08-15', 1),
('Leonardo', 'DiCaprio', '1974-11-11', 1),
('Meryl', 'Streep', '1949-06-22', 3);

SELECT COUNT(*) FROM actors;

INSERT INTO actors (first_name, last_name) VALUES ('John', 'Doe');