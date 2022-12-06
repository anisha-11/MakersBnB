require 'database_connection'
require 'space_repository'
require 'pg'

def reset_spaces_table
  seed_sql = File.read('spec/sprint_1_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe SpaceRepository do
  before(:each) do
    reset_spaces_table
  end

context 'with 4 spaces in the table' do
  it 'prints all spaces' do
    repo = SpaceRepository.new
    spaces = repo.all
    expect(spaces.length).to eq 4# =>  4
    expect(spaces[0].id).to eq 1 # =>  1
    expect(spaces[0].name).to eq "House" # =>  'House'
    expect(spaces[0].description).to eq "Stunning two bedroom house with a garden" # =>  'Stunning two bedroom house with a garden'
    expect(spaces[0].price).to eq "$99.99" # =>  99.99
    expect(spaces[0].account_id).to eq 1 # =>  1
    expect(spaces[1].id).to eq 2 # =>  2
    expect(spaces[1].name).to eq'Flat' # =>  'Flat'
    expect(spaces[1].description).to eq 'Terrible one bedroom house with a balcony' # =>  'Terrible one bedroom house with a balcony'
    expect(spaces[1].price).to eq "$2.99" # =>  2.99
    expect(spaces[1].account_id).to eq 1 # =>  1
    end
  end
end
