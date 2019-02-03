class CargoTrain < Train
  include Validation

  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number, :cargo)
  end

  def to_str
    super << ', type: Cargo'
  end
end
