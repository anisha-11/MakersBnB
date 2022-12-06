require 'account_repository'

RSpec.describe AccountRepository do 

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

end