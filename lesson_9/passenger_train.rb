class PassengerTrain < Train
  include Validation

  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number, :passenger)
  end

  def to_str
    super << ', type: Passenger'
  end
end
