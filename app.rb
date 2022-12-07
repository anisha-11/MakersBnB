require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/space_repository'
require_relative 'lib/database_connection'
require_relative 'lib/account_repository'

if ENV['ENV'] == 'test'
  DatabaseConnection.connect("makersbnb_test")
else
  DatabaseConnection.connect("makersbnb")
end

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/space_repository'
  end

  get '/' do
    @error_message = ''
    return erb(:index)
  end

  get '/spaces' do
    repo = SpaceRepository.new
    @spaces = repo.all
    return erb(:spaces)
  end

  get '/spaces/new' do
    return erb(:new_space)
  end

  post '/spaces/new' do
    repo = SpaceRepository.new
    new_space = Space.new
    new_space.name = params[:name]
    new_space.description = params[:description]
    new_space.price = params[:price]
    repo.create(new_space)
    return erb(:listed_space)
  end

  post '/' do

    @password = params[:password_confirmation]
    @password_confirmation = params[:password] 
    @name = params[:name]
    email = params[:email]

    if password_confirmation?
      @error_message = 'Passwords do not match. Please re-submit.'
      return erb(:index)
    end 

    repo = AccountRepository.new

    repo.all.each do |account|
      if account.email == email
        @error_message = 'Email already registered. Please re-submit or sign-in.'
        return erb(:index)
      end 
    end 
    
    new_account = Account.new
    
    new_account.email = email
    new_account.password = @password
    new_account.name = @name 
    new_account.dob = params[:dob]

    repo.create(new_account)

    return erb(:signup_confirmation)
  end

  get '/sessions/new' do 
    return erb(:login)
  end 

  post '/sessions/new' do 
    repo = AccountRepository.new
    user = Account.new
    user.email = params[:email]
    user.password = params[:password]

    repo.sign_in(user.email, user.password)
  end

  get '/spaces/:id' do
    repo = SpaceRepository.new
    id = params[:id]
    @space = repo.find(id)

    return erb(:new_request)
  end

  private

  def password_confirmation?
    return @password_confirmation != @password
  end

end
