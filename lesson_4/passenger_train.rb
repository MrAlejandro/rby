class PassengerTrain < Train
  def initialize(number)
    super(number, TYPE)
  end

  # этот метод вынесен из базового класса поскольку
  # со временем может понадобится определять подходит ли вагон пользователя
  # по каким то другим критериям (например наличию купе для инвалидов, или почтовый вагон)
  # И совпадение типа поезда и вагона - это случайность
  def hook_car(car)
    super(car) if car.is_of_type?(TYPE)
  end

  def to_str
    super << ", type: Passenger"
  end

  private
  TYPE = :passenger
end