require 'booking_repository'

RSpec.describe BookingRepository do 

  def reset_bookings_table
    seed_sql = File.read('spec/sprint_1_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
    connection.exec(seed_sql)
  end

  describe BookingRepository do
    before(:each) do 
      reset_bookings_table
    end

    it "gets all bookings" do
      repo = BookingRepository.new

      bookings = repo.all

      expect(bookings.length).to eq 4

      expect(bookings.first.id).to eq 1
      expect(bookings.first.date).to eq '2022-12-15'
      expect(bookings.first.status).to eq 'Pending'
      expect(bookings.first.account_id).to eq 1
      expect(bookings.first.space_id).to eq 1

      expect(bookings.last.id).to eq 4
      expect(bookings.last.date).to eq '2023-03-25'
      expect(bookings.last.status).to eq 'Pending'
      expect(bookings.last.account_id).to eq 3
      expect(bookings.last.space_id).to eq 1
    end

    it "creates a new booking" do
      repo = BookingRepository.new
      booking = Booking.new

      booking.date = '2022-12-01'
      booking.account_id = 3
      booking.space_id = 2

      repo.create(booking)
      all_bookings = repo.all

      expect(all_bookings.last.id).to eq 5
      expect(all_bookings.last.date).to eq '2022-12-01'
      expect(all_bookings.last.status).to eq 'Pending'
      expect(all_bookings.last.account_id).to eq 3
      expect(all_bookings.last.space_id).to eq 2
    end

    it "finds a specific booking" do
      repo = BookingRepository.new

      booking = repo.find(4)

      expect(booking.id).to eq 4
      expect(booking.date).to eq '2023-03-25'
      expect(booking.status).to eq 'Pending'
      expect(booking.account_id).to eq 3
      expect(booking.space_id).to eq 1

    end 

    it 'Updates a status' do
      repo = BookingRepository.new
      booking = repo.find(1)
      booking.date = '2022-12-16'
      booking.status = 'Confirmed'
      booking.account_id = 2
      booking.space_id = 2

      repo.update(booking)

      updated_booking = repo.find(1)

      expect(updated_booking.id).to eq 1
      expect(updated_booking.date).to eq '2022-12-16'
      expect(updated_booking.status).to eq 'Confirmed'
      expect(updated_booking.account_id).to eq 2
      expect(updated_booking.space_id).to eq 2
    end
  end
end
