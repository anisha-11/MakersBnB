require 'account'
require 'bcrypt'

class AccountRepository

  def initialize(encrypter = BCrypt::Password)
    @encrypter = encrypter
  end

  def all 
    sql = 'SELECT * FROM accounts;'
    params = DatabaseConnection.exec_params(sql,[])

    accounts = []
    params.each do |record|
      accounts << record_to_account(record) 
    end 
    return accounts 
  end

  def create(account)
    encrypted_password =  @encrypter.create(account.password)
    sql = 'INSERT INTO accounts (name, email, password, dob) VALUES ($1, $2, $3, $4);'
    params = [account.name, account.email, encrypted_password, account.dob]
    DatabaseConnection.exec_params(sql, params)    

    return nil
  end
  
  private 

  def record_to_account(record)
    account = Account.new
    account.id = record['id'].to_i
    account.name = record['name']
    account.email = record['email']
    account.password = record['password']
    account.dob = record['dob']
    return account
  end 
end 
