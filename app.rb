require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/space_repository'
require_relative 'lib/database_connection'


DatabaseConnection.connect("makersbnb_test")

  class Application < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
      also_reload 'lib/space_repository'
    end

    get '/' do
      return erb(:index)
    end


    get '/spaces' do
      repo = SpaceRepository.new
      @spaces = repo.all
      return erb(:spaces)
    end
  end
