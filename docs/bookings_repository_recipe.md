# Account Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

```
# EXAMPLE

Table: accounts

Columns:



```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
TRUNCATE TABLE bookings RESTART IDENTITY CASCADE;

INSERT INTO bookings (date, status, account_id, space_id) VALUES
('2022-12-15', 'Pending', 1, 1),
('2023-01-01', 'Confirmed', 4, 2),
('2023-06-25', 'Denied', 4, 3),
('2023-03-25', 'Pending', 3, 1);



```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 makersbnb_test < /spec/sprint_1_seeds.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: accounts

# Model class
# (in lib/booking.rb)
class Booking
end

# Repository class
# (in lib/booking_repository.rb)
class BookingRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: accounts

# Model class
# (in lib/account.rb)

class Booking
  # Replace the attributes by your own columns.
  attr_accessor :id, :date, :status, :account_id, :space_id
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: Bookings

# Repository class
# (in lib/account_repository.rb)

class BookingRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, date, status, account_id, space_id FROM bookings;

    # Returns an array of Account objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
  #   # Executes the SQL query:
   SELECT id, date, status, account_id, space_id FROM spaces WHERE id = $1;

  #   # Returns a single Account object.
  end

  def create(booking)
    # Account is an instance of Account object
    # INSERT INTO bookings ( date, status, account_id, space_id) VALUES ($1, $2, $3, $4);
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
# Get all accounts

 xit "gets all bookings" do
      repo = BookingRepository.new

      bookings = repo.all

      expect(bookings.length).to eq 4

      expect(bookings.first.id).to eq 1
      expect(bookings.first.date).to eq '2022-12-15'
      expect(bookings.first.status).to eq 'Pending'
      expect(bookings.first.account_id).to eq 1
      expect(bookings.first.space_id).to eq 1

      expect(bookings.last.id).to eq 4
      expect(bookings.last.date).to eq '2023-03-25'
      expect(bookings.last.status).to eq 'Pending'
      expect(bookings.last.account_id).to eq 3
      expect(bookings.last.space_id).to eq 1
    end


# 2
# Create a single account

 xit "creates a new booking" do
      repo = BookingRepository.new
      booking = Booking.new


      booking.date = '2022-12-01'
      booking.status = 'Pending'
      booking.account_id = 3
      booking.space_id = 2

      repo.create(booking)
      all_bookings = repo.all


      expect(all_bookings.last.id).to eq 5
      expect(all_bookings.last.date).to eq '2022-12-01'
      expect(all_bookings.last.status).to eq 'Pending'
      expect(all_bookings.last.account_id).to eq 3
      expect(all_bookings.last.space_id).to eq 2
    end


xit "finds a specific booking"
    repo = BookingRepository.new

    booking = repo.find(4)

    expect(booking.id).to eq 4
    expect(booking.date).to eq '2023-03-25'
    expect(booking.status).to eq 'Pending'
    expect(booking.account_id).to eq 3
    expect(booking.space_id).to eq 1

```


Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/accounts_repository_spec.rb

def reset_accounts_table
  seed_sql = File.read('spec/sprint_1_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end


describe AccountRepository do
  before(:each) do
    reset_accounts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->
