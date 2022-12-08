require_relative './account'
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

  def find_by_email(email)
    sql = 'SELECT * FROM accounts WHERE email = $1;'
    result_set = DatabaseConnection.exec_params(sql, [email])
    if result_set.num_tuples.zero?
      return false
    else
      record = result_set[0]
    return record_to_account(record)
    end
  end

  # def sign_in(email, submitted_password)
  #   user = find_by_email(email)

  #   return nil if user.nil?

  #   # Compare the submitted password with the encrypted one saved in the database
  #   if BCrypt::Password.new(user.password) == submitted_password
  #     return 'login success'
  #   else
  #     return 'wrong password'
  #   end
  # end
  
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
