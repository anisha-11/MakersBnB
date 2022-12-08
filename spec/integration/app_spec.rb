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
      expect(response.body).to include('<form action="/sessions/new" method="GET">')
      expect(response.body).to include('<input type="submit" value="Login" class="button">')
    end
  end

  context 'POST /' do
    it 'creates a new account and return confirmation page' do
      response = post("/", name: "Thomas Seleiro", email: "ThomasSeleiro@fakeemail.com", dob: "2000-12-01", password: "test1234", password_confirmation: "test1234")
      expect(response.status).to eq(200)
      expect(response.body).to include('<h2>Sign up complete for Thomas Seleiro</h2>')
      expect(response.body).to include('<a href="/sessions/new">Login to MakersBnB</a>')
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
    end
  end

  context 'for POST /sessions/new' do
    it 'logs in user' do
      response = post("/", name: "Thomas Seleiro", email: "ThomasSeleiro@fakeemail.com", dob: "2000-12-01", password: "test1234", password_confirmation: "test1234")
      expect(response.status).to eq(200)
      expect(response.body).to include('<h2>Sign up complete for Thomas Seleiro</h2>')
      response = post("/sessions/new", email: "ThomasSeleiro@fakeemail.com", password: "test1234")
      expect(response.status).to eq 302
    end
  end

    it "returns a login error and redirects to login" do
      response = post("/", name: "Thomas Seleiro", email: "ThomasSeleiro@fakeemail.com", dob: "2000-12-01", password: "test1234", password_confirmation: "test1234")
      expect(response.status).to eq(200)
      expect(response.body).to include('<h2>Sign up complete for Thomas Seleiro</h2>')
      response = post("/sessions/new", email: "ThomasSeleiro@fakeemail.com", password: "test4321")
      expect(response.status).to eq 200
      expect(response.body).to include('<h2>Login to MakersBnB</h2>')
      expect(response.body).to include('<form action="/sessions/new" method="POST">')
      expect(response.body).to include('</form>')
      expect(response.body).to include('<label>Email Address</label>')
      expect(response.body).to include('<input type="email" name="email" maxlength="100" required>')
      expect(response.body).to include('<label>Password</label>')
      expect(response.body).to include('<input type="password" name="password" minlength="8" maxlength="8" required>')
      expect(response.body).to include('<input type="submit" value="Login" class="button">')
    end

    it "returns an email error and redirects to login" do
      response = post("/", name: "Thomas Seleiro", email: "ThomasSeleiro@fakeemail.com", dob: "2000-12-01", password: "test1234", password_confirmation: "test1234")
      expect(response.status).to eq(200)
      expect(response.body).to include('<h2>Sign up complete for Thomas Seleiro</h2>')
      response = post("/sessions/new", email: "Seleiro@fakeemail.com", password: "test4321")
      expect(response.status).to eq 200
      expect(response.body).to include('<h2>Login to MakersBnB</h2>')
      expect(response.body).to include('<form action="/sessions/new" method="POST">')
      expect(response.body).to include('</form>')
      expect(response.body).to include('<label>Email Address</label>')
      expect(response.body).to include('<input type="email" name="email" maxlength="100" required>')
      expect(response.body).to include('<label>Password</label>')
      expect(response.body).to include('<input type="password" name="password" minlength="8" maxlength="8" required>')
      expect(response.body).to include('<input type="submit" value="Login" class="button">')
    end

  context 'GET /spaces' do
    it 'should get a page of all spaces' do
      response = get('/spaces')

      expect(response.status).to eq 200
      expect(response.body).to include '<h1>Book a Space</h1>'
      expect(response.body).to include '<h2><a href="/spaces/1">House</a></h2>'
      expect(response.body).to include '<h2><a href="/spaces/2">Flat</a></h2>'
      expect(response.body).to include '<h2><a href="/spaces/3">Tree House</a></h2>'
      expect(response.body).to include '<a href="/spaces/new">List a space</a>'
    end

    it "adds an ellipsis when the description is longer than 20 characters" do
      response = get('/spaces')
      expect(response.status).to eq 200
      expect(response.body).to include 'Stunning two bedroom ...'
    end

    it "has a logout link" do
      response = get('/spaces')
      expect(response.status).to eq 200
      expect(response.body).to include '<form action="/logout" method="GET">'
      expect(response.body).to include '<input type="submit" value="Sign out" style="float: right;" class="button">'
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
      expect(response.body).to include '<h2><a href="/spaces/5">Luxury spa</a></h2>'
    end
  end


  context "for GET /spaces/:id" do
     it "returns info from space 1" do
       response = post("/", name: "Thomas Seleiro", email: "ThomasSeleiro@fakeemail.com", dob: "2000-12-01", password: "test1234", password_confirmation: "test1234")
       expect(response.status).to eq(200)
       expect(response.body).to include('<h2>Sign up complete for Thomas Seleiro</h2>')
       response = post("/sessions/new", email: "ThomasSeleiro@fakeemail.com", password: "test1234")
       expect(response.status).to eq 302
       response = get("/spaces/1")
       expect(response.body).to include('<h2>House</h2>')
       expect(response.body).to include('Stunning two bedroom house with a garden')
       expect(response.body).to include('$99.99')
       expect(response.body).to include('<label>Pick a night</label>')
       expect(response.body).to include('<input type="date" name="date" required>')
       expect(response.body).to include('<input type="submit" value="Request to Book" class="button">')
       expect(response.body).to include('<form action="/spaces/request" method="POST">')
       expect(response.body).to include('</form>')

     end
     it "returns info from space 2" do
       response = post("/", name: "Thomas Seleiro", email: "ThomasSeleiro@fakeemail.com", dob: "2000-12-01", password: "test1234", password_confirmation: "test1234")
       expect(response.status).to eq(200)
       expect(response.body).to include('<h2>Sign up complete for Thomas Seleiro</h2>')
       response = post("/sessions/new", email: "ThomasSeleiro@fakeemail.com", password: "test1234")
       expect(response.status).to eq 302
       response = get("/spaces/2")
       expect(response.body).to include('<h2>Flat</h2>')
       expect(response.body).to include('Terrible one bedroom house with a balcony')
       expect(response.body).to include('$2.99')
       expect(response.body).to include('<label>Pick a night</label>')
       expect(response.body).to include('<input type="date" name="date" required>')
       expect(response.body).to include('<input type="submit" value="Request to Book" class="button">')
       expect(response.body).to include('<form action="/spaces/request" method="POST">')
       expect(response.body).to include('</form>')
     end

     it "returns back to the login page if not signed in" do
       response = get("/spaces/2")
       expect(response.status).to eq(302)
     end
   end

   context "for POST /spaces/request" do
    it "adding a booking requets for space 1" do
      response = post('spaces/request', date: '2023-12-01')
      expect(response.status).to eq 200
      expect(response.body).to include 'Your booking has been requested'
      expect(response.body).to include '<a href="/spaces"> Back to listings</a>'
    end
   end

  context "GET /logout" do
    it "takes you to a logout page" do
      response = get('/logout')
      expect(response.status).to eq 200
      expect(response.body).to include('<h2>Are you sure you want to logout?</h2>')
      expect(response.body).to include('<form action="/logout" method="POST">')
      expect(response.body).to include('<input type="submit" value="Logout" class="button_small">')
      expect(response.body).to include('<form action="/spaces" method="GET">')
      expect(response.body).to include('<input type="submit" value="Return" class="button_small">')
    end
  end

  context "POST /logout" do
    it "it logs user out" do
      response = post('/logout')
      expect(response.status).to eq 302
    end
  end


  context "for GET /requests/:id" do
    it "returns info from request 1" do
      response = get("/requests/1")
      expect(response.status).to eq 200
      expect(response.body).to include('<h2>House</h2>')
      expect(response.body).to include('Stunning two bedroom house with a garden')
      expect(response.body).to include('From: chrishutchinson@fakeemail.com')
      expect(response.body).to include('Date: 2022-12-15')
      expect(response.body).to include('<input type="submit" name="status" value="Confirm Request" class="button">')
      expect(response.body).to include('<input type="submit" name="status" value="Deny Request" class="button">')
      expect(response.body).to include('<form action="/requests/confirm" method="POST">')
      expect(response.body).to include('</form>')
    end
  end

  context "for POST /requests/confirm" do
   it "modify the status of the booking table to confirmed" do
     response = get("/requests/1")
     expect(response.status).to eq 200

     response = post('requests/confirm', status: 'Confirm Request')
     expect(response.status).to eq 200
     # expect(response.body).to include 'Your booking has been requested'
     # expect(response.body).to include '<a href="/spaces"> Back to listings</a>'
   end
  end
end
