class Station
  attr_reader :trains

  include InstanceCounter

  @@stations = []

  def self.stations
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate
    @@stations << self
    register_instance
  end

  def valid?
    validate
    true
  rescue
    false
  end

  def handle_arrival(train)
    @trains << train
    self
  end

  def get_trains_by_type(type)
    @trains.select { |train| train.is_of_type?(type) }
  end

  def get_trains_quantity_by_type(type)
    get_trains_by_type(type).size
  end

  def handle_departure(train)
    @trains.delete(train)
  end

  def has_trains?
    @trains.size > 0
  end

  def to_str
    @name
  end

  protected

  def validate
    raise "Station name cannot be empty." if @name == nil || @name.empty?
  end
end
