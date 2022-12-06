require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

def reset_spaces_table
  seed_sql = File.read('spec/sprint_1_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.


  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
    end
  end

  context 'GET /spaces' do
    it 'should get a page of all spaces' do
      response = get('/spaces')

      expect(response.status).to eq 200
      expect(response.body).to include '<h1>Book a Space</h1>'
      expect(response.body).to include '<h2>House</h2>'
      expect(response.body).to include '<h2>Flat</h2>'
      expect(response.body).to include '<h2>Tree House</h2>'
      expect(response.body).to include '<a href="/spaces/new"> List a space</a>'
    end
  end

  context 'GET /spaces/new' do
    it 'should get a page to add a new space' do
      response = get('/spaces/new')

      expect(response.status).to eq 200
      expect(response.body).to include '<h1>List a Space</h1>'
      expect(response.body).to include '<input type="submit" value="List my Space" />'
      expect(response.body).to include '<input type="text" name="price" required> <br/>'
      expect(response.body).to include '<input type="text" name="description" required> <br/>'
      expect(response.body).to include '<input type="text" name="name" required> <br/>'
      expect(response.body).to include '<input type="text" name="name" required> <br/>'

    end
  end
end
