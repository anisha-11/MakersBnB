require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/account_repository'


class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/' do
    repo = AccountRepository.new
    new_account = Account.new

    new_account.email = params[:email]
    new_account.password = params[:password]
    @name = params[:name]
    new_account.name = @name 
    new_account.dob = params[:dob]

    repo.create(new_account)

    return erb(:signup_confirmation)
  end

end