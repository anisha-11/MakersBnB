# Peep Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

```
# EXAMPLE

Table: spaces

Columns:
id | name | description | price | account_id
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
TRUNCATE TABLE accounts, spaces RESTART IDENTITY CASCADE;

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
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: spaces

# Model class
# (in lib/space.rb)
class Space
end

# Repository class
# (in lib/space_repository.rb)
class SpaceRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: spaces

# Model class
# (in lib/space.rb)

class Space
  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :description, :price, :account_id
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: spaces

# Repository class
# (in lib/space_repository.rb)

class SpaceRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, description, price, account_id FROM Spaces;

    # Returns an array of Space objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, description, price, account_id FROM spaces WHERE id = $1;

    # Returns a single Space object.
  end

  def create(space)
    # space is an instance of space object
    # INSERT INTO spaces (name, description, price, account_id) VALUES ($1, $2, $3, $4);
    # Returns nothing
  end

  def delete(id)
    # id is an integer
    # DELETE FROM spaces WHERE id = $1;
    # Returns nothing
  end

  def update(space)
    # space is an instance of space object
    # UPDATE spaces SET name = $1, description = $2, price = $3, account_id = $4 WHERE id = $5;
    # Returns nothing
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all spaces

repo = SpaceRepository.new

spaces = repo.all

spaces.length # =>  4

spaces[0].id # =>  1
spaces[0].name # =>  'House'
spaces[0].description # =>  'Stunning two bedroom house with a garden'
spaces[0].price # =>  99.99
spaces[0].account_id # =>  1

spaces[1].id # =>  2
spaces[1].name # =>  'Flat'
spaces[1].description # =>  'Terrible one bedroom house with a balcony'
spaces[1].price # =>  2.99
spaces[1].account_id # =>  1

# 2
# Get a single space

repo = SpaceRepository.new

space = repo.find(3)

space.id # =>  3
space.name # =>  'Tree House'
space.description # =>  'A woody, insect ridden residence in a tree with no bedrooms'
space.price # =>  2000.01
space.account_id # =>  3

# 3
# Create a single space

repo = SpaceRepository.new
space = Space.new
space.name #=> 'Lovely maisonette'
space.description #=> 'A very lovely maisonette'
space.price #=> 100.00
space.account_id #=> 4
repo.create(space)

all_spaces = repo.all
all_spaces.last.id #=> 5
all_spaces.last.name #=> 'Lovely maisonette'
all_spaces.last.price #=> 100.00
all_spaces.last.account_id #=> 4
all_spaces.last.description #=> 'A very lovely maisonette'

# 4
# Delete a single space
repo = SpaceRepository.new
repo.delete(3)
spaces = repo.all
spaces.length #=> 3
spaces[0].id #=> 1
spaces[1].id #=> 2
spaces[2].id #=> 4

# 5
# Update a single space
repo = SpaceRepository.new
new_space = repo.find(2)
new_space.name = 'Studio'
new_space.description = 'Terrible studio with rats'
new_space.price = 3.00
repo.update(new_space)
space = repo.find(2)
space.name # => 'Studio'
space.description # => 'Terrible studio with rats'
space.price # => 3.00
space.account_id # => 1

# 6
# Deleting account deletes all posts linked to it
account_repo = AccountReporsitory.new
post_repo = PostReporsitory.new
account_repo.delete(1)
all_posts = post_repo.all
all_posts.length # => 2
all_posts.first.id # => 2
all_posts.first.title # => "Title 2"
all_posts.first.contents # => "Contents 2"
all_posts.first.views # => 100
all_posts.first.account_id # => 2
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/posts_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
end
```
