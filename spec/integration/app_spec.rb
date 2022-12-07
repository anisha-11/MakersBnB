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
      expect(response.body).to include('<input type="submit" value="Sign Up" class="button">')
      expect(response.body).to include('<a href="/sessions/new">Login</a>')
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

    it 'returns error message on signup page, when email is duplicated' do 
      response = post("/", name: "Thomas Seleiro", email: "chrishutchinson@fakeemail.com", dob: "2000-12-01", password: "test1234", password_confirmation: "test1234")
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Feel at home, anywhere</h1>')
      expect(response.body).to include('<h2>Sign up to MakersBnB</h2>')
      expect(response.body).to include('<p>Email already registered. Please re-submit or sign-in.</p>')
    end
  end

  context "GET '/sessions/new' " do 
    it "get the login page" do 
      response = get('/sessions/new')
      expect(response.status).to eq 200
      expect(response.body).to include('<h2>Login to MakersBnB</h2>')
      expect(response.body).to include('<form action="/sessions/new" method="POST">')
      expect(response.body).to include('</form>')
      expect(response.body).to include('<label>Email Address</label>')
      expect(response.body).to include('<input type="email" name="email" maxlength="100" required>')
      expect(response.body).to include('<label>Password</label>')
      expect(response.body).to include('<input type="password" name="password" minlength="8" maxlength="8" required>')
      expect(response.body).to include('<input type="submit" value="Login" class="button">')
      expect(response.body).to include('<a href="/sessions/new">Login</a>')
    end
  end

  context 'for POST /sessions/new' do
    it 'logs in user' do
      response = post("/", name: "Thomas Seleiro", email: "ThomasSeleiro@fakeemail.com", dob: "2000-12-01", password: "test1234", password_confirmation: "test1234")
      expect(response.status).to eq(200)
      expect(response.body).to include('<h2>Sign up complete for Thomas Seleiro</h2>')
      response = post("/sessions/new", email: "ThomasSeleiro@fakeemail.com", password: "test1234")  
      expect(response.status).to eq 200
      expect(response.body).to eq "login success"
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

    it "adds an ellipsis when the description is longer than 20 characters" do
      response = get('/spaces')
      expect(response.status).to eq 200
      expect(response.body).to include 'Stunning two bedroom...'
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
      expect(response.body).to include '<a href="/spaces"> Back to listings</a>'
    end
  end

  context "POST /spaces/new" do
    it "should create a new space" do
      response = post('spaces/new', name: 'Luxury spa', description: 'A luxurious spa retreat', price: 199.99)

      expect(response.status).to eq 200
      expect(response.body).to include 'Your space has been listed'
      expect(response.body).to include '<a href="/spaces"> Back to listings</a>'

      response = get('/spaces')
      expect(response.body).to include '<h2>Luxury spa</h2>'
    end
  end
end
