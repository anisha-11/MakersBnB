# Sprint 1 Tables Design Recipe Template

_Copy this recipe template to design and create two related database tables from a specification._

## 1. Extract nouns from the user stories or specification

```
# EXAMPLE USER STORY:
# (analyse only the relevant part - here the final line).

As a user 
So I can sign up
I want to create account
I want to enter Email, Name, Password, DOB (18 or over)

As a user 
So that I can list a space (add user_id to table)
I want to add name of space
I want to provide a short description of space
I want to add price per night

As a user
I want to add multiple spaces


```

```
Nouns:

account, email, name, password, DOB
space, name, description, price

```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| account               | name, email, password, DOB
| space                 | name, description, price

1. Name of the first table (always plural): `accounts` 

    Column names: `name`, `email`, `password`, `DOB`

2. Name of the second table (always plural): `space` 

    Column names: `name`, `description`, `price`

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

Table: accounts
id: SERIAL
name: text
email: text 
password: text
DOB: date

Table: spaces
id: SERIAL
name: text
description: text
price: money

```

## 4. Decide on The Tables Relationship

Most of the time, you'll be using a **one-to-many** relationship, and will need a **foreign key** on one of the two tables.

To decide on which one, answer these two questions:

1. Can one [TABLE ONE] have many [TABLE TWO]? (Yes/No)
2. Can one [TABLE TWO] have many [TABLE ONE]? (Yes/No)

You'll then be able to say that:

1. **[A] has many [B]**
2. And on the other side, **[B] belongs to [A]**
3. In that case, the foreign key is in the table [B]

Replace the relevant bits in this example with your own:

```
# EXAMPLE

1. Can one acount have many spaces? YES
2. Can one space have many accounts? NO

-> Therefore,
-> An account HAS MANY spaces
-> An space BELONGS TO an account

-> Therefore, the foreign key is on the spaces table.
```

*If you can answer YES to the two questions, you'll probably have to implement a Many-to-Many relationship, which is more complex and needs a third table (called a join table).*

## 4. Write the SQL.

```sql
-- EXAMPLE
-- file: sprint_1_tables.sql

-- Replace the table name, columm names and types.

-- Create the table without the foreign key first.
CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  name text,
  email text, 
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

```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 makersbnb < docs/sprint_1_tables.sql
```

