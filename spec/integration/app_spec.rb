require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'



def reset_makersbnb_database
  seed_sql = File.read('spec/sprint_1_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe Application do

  before(:each) do
    reset_makersbnb_database
  end
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
      expect(response.body).to include('<h1>Feel at home, anywhere</h1>')
      expect(response.body).to include('<h2>Sign up to MakersBnB</h2>')
      expect(response.body).to include('<form action="/" method="POST">')
      expect(response.body).to include('</form>')
      expect(response.body).to include('<label>Name</label>')
      expect(response.body).to include('<input type="text" name="name" maxlength="100" required>')
      expect(response.body).to include('<label>Email Address</label>')
      expect(response.body).to include('<input type="email" name="email" maxlength="100" required>')
      expect(response.body).to include('<label>Date of Birth</label>')
      expect(response.body).to include('<input type="date" name="dob" required>')
      expect(response.body).to include('<label>Password</label>')
      expect(response.body).to include('<input type="password" name="password" minlength="8" maxlength="8" required>')
      expect(response.body).to include('<label>Password Confirmation</label>')
      expect(response.body).to include('<input type="password" name="password_confirmation" minlength="8" maxlength="8" required>')
      expect(response.body).to include('<input type="submit" value="Sign Up">')
    end
  end

  context 'POST /' do
    it 'creates a new account and return confirmation page' do
      response = post("/", name: "Thomas Seleiro", email: "ThomasSeleiro@fakeemail.com", dob: "2000-12-01", password: "test1234", password_confirmation: "test1234")
      expect(response.status).to eq(200)
      expect(response.body).to include('<h2>Sign up complete for Thomas Seleiro</h2>')
      expect(response.body).to include('<a href="/spaces">View spaces</a>')
    end

    it 'returns error message on signup page, when passwords do not match' do
      response = post("/", name: "Thomas Seleiro", email: "ThomasSeleiro@fakeemail.com", dob: "2000-12-01", password: "test1234", password_confirmation: "test4321")
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Feel at home, anywhere</h1>')
      expect(response.body).to include('<h2>Sign up to MakersBnB</h2>')
      expect(response.body).to include('<p>Passwords do not match. Please re-submit.</p>')
    end
  end

end
