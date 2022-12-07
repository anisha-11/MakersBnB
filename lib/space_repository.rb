require_relative './space'

class SpaceRepository
  def all
    sql = "SELECT id, name, description, price, account_id FROM spaces;"
    result_set = DatabaseConnection.exec_params(sql, [])
    spaces = []
    result_set.each do |record|
      space = Space.new
      space.id = record["id"].to_i
      space.name = record["name"]
      space.description = record["description"]
      space.price = record["price"]
      space.account_id = record["account_id"].to_i
      spaces.push(space)
    end
    return spaces
  end

  def find(id)
    sql = "SELECT id, name, description, price, account_id FROM spaces WHERE id = $1;"
    params = [id]
    result_set = DatabaseConnection.exec_params(sql, params)
    record = result_set[0]
    space = Space.new
    space.id = record["id"].to_i
    space.name = record["name"]
    space.description = record["description"]
    space.price = record["price"]
    space.account_id = record["account_id"].to_i
    return space
  end

  def create(space)
    sql = 'INSERT INTO spaces (name, description, price, account_id) VALUES ($1, $2, $3, $4);'
    params = [space.name, space.description, space.price, space.account_id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def delete(id)
    sql = 'DELETE FROM spaces WHERE id = $1;'
    params = [id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def update(space)
    sql = 'UPDATE spaces SET name = $1, description = $2, price = $3, account_id = $4 WHERE id = $5;'
    params = [space.name, space.description, space.price, space.account_id, space.id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end
end
