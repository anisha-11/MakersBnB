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