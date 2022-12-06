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

  it 'finds the space with an id of 3' do
    repo = SpaceRepository.new
    space = repo.find(3)
    expect(space.id).to eq 3
    expect(space.name).to eq 'Tree House'
    expect(space.description).to eq 'A woody, insect ridden residence in a tree with no bedrooms'
    expect(space.price).to eq "$2,000.01"
    expect(space.account_id).to eq 3
  end

  it 'creates a space with given parameters' do
    repo = SpaceRepository.new
    space = Space.new
    space.name = 'Lovely maisonette'
    space.description = 'A very lovely maisonette'
    space.price = 100.00
    space.account_id = 4
    repo.create(space)

    all_spaces = repo.all
    expect(all_spaces.last.id).to eq 5
    expect(all_spaces.last.name).to eq 'Lovely maisonette'
    expect(all_spaces.last.price).to eq "$100.00"
    expect(all_spaces.last.account_id).to eq 4
    expect(all_spaces.last.description).to eq 'A very lovely maisonette'
  end

  it 'deletes the specified space, leaving 3 spaces in table' do
    repo = SpaceRepository.new
    repo.delete(3)
    spaces = repo.all
    expect(spaces.length).to eq 3
    expect(spaces[0].id).to eq 1
    expect(spaces[1].id).to eq 2
    expect(spaces[2].id).to eq 4
  end

  it 'updates a specified space with new parameters' do
    repo = SpaceRepository.new
    new_space = repo.find(2)
    new_space.name = 'Studio'
    new_space.description = 'Terrible studio with rats'
    new_space.price = 3.00
    repo.update(new_space)
    space = repo.find(2)
    expect(space.name).to eq 'Studio'
    expect(space.description).to eq 'Terrible studio with rats'
    expect(space.price).to eq "$3.00"
    expect(space.account_id).to eq 1
  end
end
