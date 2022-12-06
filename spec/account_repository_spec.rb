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

    it "gets all accounts" do 
      repo = AccountRepository.new

      accounts = repo.all

      expect(accounts.length).to eq 4

      expect(accounts.first.id).to eq 1
      expect(accounts.first.name).to eq 'Chris Hutchinson'
      expect(accounts.first.email).to eq 'chrishutchinson@fakeemail.com'
      expect(accounts.first.password).to eq '$2a$12$3szom8F8U2FzRLw/9Hbtre/q7lE7T8a3PNy/yoEKVIfpMRW6DRUgm'
      expect(accounts.first.dob).to eq '1982-12-15'

      expect(accounts.last.id).to eq 4
      expect(accounts.last.name).to eq 'Valerio Franchi'
      expect(accounts.last.email).to eq 'valeriof@fakeemail.com'
      expect(accounts.last.password).to eq '$2a$12$3szom8F8U2FzRLw/9Hbtre/q7lE7T8a3PNy/yoEKVIfpMRW6DRUvf'
      expect(accounts.last.dob).to eq '1995-09-23'
    end

    xit "creates a new account" do 
      repo = AccountRepository.new
      account = Account.new


      account.name = 'Thomas Seleiro'
      account.email = 'ThomasSeleiro@fakeemail.com'
      account.password = 'test1234'
      account.dob = '1994-12-15'

      repo.create(account)
      all_accounts = repo.all


      expect(all_accounts.last.id).to eq 5
      expect(all_accounts.last.name).to eq 'Thomas Seleiro'
      expect(all_accounts.last.email).to eq 'ThomasSeleiro@fakeemail.com'
      expect(all_accounts.last.password).to eq '$2a$12$3szom8F8U2FzRLw/9Hbtre/q7lE7T8a3PNy/yoEKVIfpMRW6DRUrw'
      expect(all_accounts.last.dob).to eq '1994-12-15'
    end

    xit "fails as there is a duplicate" do 
      repo = AccountRepository.new
      account = Account.new
      accounts.name = 'Chris Hutchinson'
      accounts.email = 'chrishutchinson@fakeemail.com'
      accounts.password = '$2a$12$3szom8F8U2FzRLw/9Hbtre/q7lE7T8a3PNy/yoEKVIfpMRW6DRUgm'
      accounts.dob = '1982-12-15'

      expect { repo.create(account) }.to raise_error "Duplicate email"
    end 
  end 
end