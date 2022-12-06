require 'account'

class AccountRepository
  def all 
    sql = 'SELECT * FROM accounts;'
    params = DatabaseConnection.exec_params(sql,[])

    accounts = []
    params.each do |record|
      accounts << record_to_account(record) 
    end 
    return accounts 
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
