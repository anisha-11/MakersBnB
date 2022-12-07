DROP TABLE IF EXISTS accounts, spaces, bookings CASCADE;

CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  name text,
  email text UNIQUE, 
  password text,
  dob date
);

-- Then the table with the foreign key first.
CREATE TABLE spaces (
  id SERIAL PRIMARY KEY,
  name text,
  description text,
  price money,
-- The foreign key name is always {other_table_singular}_id
  account_id int,
  constraint fk_account foreign key(account_id)
    references accounts(id)
    on delete cascade
);

-- Then the table with the foreign key first.
CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  date date,
  status text,
-- The foreign key name is always {other_table_singular}_id
  account_id int,
  constraint fk_account foreign key(account_id)
    references accounts(id)
    on delete cascade,
  space_id int,
  constraint fk_space foreign key(space_id)
    references spaces(id)
    on delete cascade
);


-- TRUNCATE TABLE accounts RESTART IDENTITY CASCADE;

INSERT INTO accounts (name, email, password, dob) VALUES 
('Chris Hutchinson', 'chrishutchinson@fakeemail.com', '$2a$12$3szom8F8U2FzRLw/9Hbtre/q7lE7T8a3PNy/yoEKVIfpMRW6DRUgm', '1982-12-15'),
('Robbie Kirkbride', 'robbiek@fakeemail.com', '$2a$12$3szom8F8U2FzRLw/9Hbtre/q7lE7T8a3PNy/yoEKVIfpMRW6DRUrk', '1994-07-22'),
('Anisha Hirani', 'anishah@fakeemail.com', '$2a$12$3szom8F8U2FzRLw/9Hbtre/q7lE7T8a3PNy/yoEKVIfpMRW6DRUah', '2003-10-11'),
('Valerio Franchi', 'valeriof@fakeemail.com', '$2a$12$3szom8F8U2FzRLw/9Hbtre/q7lE7T8a3PNy/yoEKVIfpMRW6DRUvf', '1995-09-23');



INSERT INTO spaces (name, description, price, account_id) VALUES
('House', 'Stunning two bedroom house with a garden', 99.99, 1),
('Flat', 'Terrible one bedroom house with a balcony', 2.99, 1),
('Tree House', 'A woody, insect ridden residence in a tree with no bedrooms', 2000.01, 3),
('Bungalow', 'A seaside bungalow with one bedroom', 50.00, 2);

INSERT INTO bookings (date, status, account_id, space_id) VALUES 
('2022-12-15', 'Pending', 1, 1),
('2023-01-01', 'Confirmed', 4, 2),
('2023-06-25', 'Denied', 4, 3),
('2023-03-25', 'Pending', 3, 1);