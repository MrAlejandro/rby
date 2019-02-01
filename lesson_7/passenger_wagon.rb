class PassengerWagon < Wagon
  def initialize(seats)
    @seats = seats.to_i
    @reserved_seats = 0
    super(:passenger)
  end

  def reserve_seat
    @reserved_seats += 1 if @reserved_seats < @seats
  end

  def reserved_seats_number
    @reserved_seats
  end

  def free_seats_number
    @seats - @reserved_seats
  end

  protected

  def validate
    raise "Number of seats must be greater than zero." if @seats.zero?
    super()
  end
end
