class CargoTrain < Train
  def initialize(number)
    super(number, TYPE)
  end

  def hook_car(car)
    super(car) if car.is_of_type?(TYPE)
  end

  def to_str
    super << ", type: Cargo"
  end

  private
  TYPE = :cargo
end