class PassengerWagon < Wagon
  attr_reader :reserved_seats

  def initialize(seats)
    @seats = seats.to_i
    @reserved_seats = 0
    super(:passenger)
  end

  def reserve_seat
    @reserved_seats += 1 if @reserved_seats < @seats
  end

  def free_seats
    @seats - @reserved_seats
  end

  def to_str
    "Passenger wagon. Seats: #{@seats}, reserved: #{@reserved_seats}, free: #{free_seats}."
  end

  protected

  def validate
    raise 'Number of seats must be greater than zero.' if @seats.zero?

    super()
  end
end
