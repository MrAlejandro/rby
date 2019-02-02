class CargoTrain < Train
  def initialize(number)
    super(number, :cargo)
  end

  def to_str
    super << ", type: Cargo"
  end
end
