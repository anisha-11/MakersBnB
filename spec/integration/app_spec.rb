require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

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
      expect(response.body).to include('<h1>Feel at home, anywhere</h1>')
      expect(response.body).to include('<h2>Sign up to MakersBnB</h2>')
      expect(response.body).to include('<form action="/" method="POST">')
      expect(response.body).to include('</form>')
      expect(response.body).to include('<label>Email Address</label>')
      expect(response.body).to include('<input type="text" name="email" maxlength="100" required>')
      expect(response.body).to include('<label>Password</label>')
      expect(response.body).to include('<input type="password" name="password" maxlength="8" required>')
      expect(response.body).to include('<label>Password Confirmation</label>')
      expect(response.body).to include('<input type="password" name="password_confirmation" maxlength="8" required>')
      expect(response.body).to include('<input type="submit" value="Sign Up">')
    end
  end
end
