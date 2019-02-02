class PassengerTrain < Train
  def initialize(number)
    super(number, :passenger)
  end

  def to_str
    super << ', type: Passenger'
  end
end
