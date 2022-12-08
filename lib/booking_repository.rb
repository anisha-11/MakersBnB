require_relative './booking'

class BookingRepository

  def all
    sql = 'SELECT id, date, status, account_id, space_id FROM bookings;'
    params = DatabaseConnection.exec_params(sql,[])

    bookings = []
    params.each do |record|
      bookings << record_to_booking(record)
    end

    return bookings
  end

  def find(id)
    sql = 'SELECT id, date, status, account_id, space_id FROM bookings WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    record = result_set[0]
    return record_to_booking(record)
  end

  def create(booking)
    status = "Pending"
    sql = 'INSERT INTO bookings (date, status, account_id, space_id) VALUES ($1, $2, $3, $4);'
    params = [booking.date, status, booking.account_id, booking.space_id]
    DatabaseConnection.exec_params(sql, params)

    return nil
  end

  def update(booking)
    sql = 'UPDATE bookings SET date = $1 , status = $2 , account_id = $3, space_id = $4 WHERE id = $5;'
    params = [booking.date, booking.status, booking.account_id, booking.space_id, booking.id]

    DatabaseConnection.exec_params(sql, params)

    return nil

  end


  private

  def record_to_booking(record)
    booking = Booking.new
    booking.id = record['id'].to_i
    booking.date = record['date']
    booking.status = record['status']
    booking.account_id = record['account_id'].to_i
    booking.space_id = record['space_id'].to_i
    return  booking
  end 

end

