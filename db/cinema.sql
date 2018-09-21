DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  funds FLOAT,
  type VARCHAR(255) -- check if it could be a separate table
);

CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(255),
  price FLOAT
);

CREATE TABLE screenings (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR
  capacity INT4,
  film_id INT4 REFERENCES films(id) ON DELETE CASCADE,
  start_time TIMESTAMP
);

CREATE TABLE tickets (
  id SERIAL4 PRIMARY KEY,
  customer_id INT4 REFERENCES customers(id) ON DELETE CASCADE,
  screening_id INT4 REFERENCES screenings(id) ON DELETE CASCADE,
  cost FLOAT
);
