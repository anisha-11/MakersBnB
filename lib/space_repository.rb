require 'space'


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
end
