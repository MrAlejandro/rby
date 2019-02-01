class Train
  attr_reader :wagons, :current_station, :number
  attr_accessor :speed

  include Manufacturer
  include InstanceCounter

  TYPES = [:cargo, :passenger]
  NUMBER_FORMAT = /^[\w\d]{3}-?[\w\d]{2}$/

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @current_station = nil
    validate
    @@trains[number] = self
    register_instance
  end

  def valid?
    validate
    true
  rescue
    false
  end

  def break
    @speed = 0
  end

  def is_of_type?(type)
    @type == type
  end

  def wagon_number
    @wagons.size
  end

  def hook_wagon(wagon)
    can_hook = @speed == 0 || @wagons.none?(wagon) || wagon.is_a?(Wagon) || wagon.is_of_type?(@type)
    @wagons << wagon if can_hook
  end

  def unhook_wagon(wagon)
    @wagons.delete(wagon) if @speed == 0
  end

  def route=(route)
    @route = route
    @current_station = route.initial_station
    route.initial_station.handle_arrival(self)
  end

  def go_forward
    next_station = get_next_station
    go_to_station(next_station) if next_station
  end

  def go_back
    prev_station = get_prev_station
    go_to_station(prev_station) if prev_station
  end

  def get_next_station
    @route.get_station_after(@current_station)
  end

  def get_prev_station
    @route.get_station_before(@current_station)
  end

  def each_wagon
    @wagons.each {|wagon| yield wagon}
  end

  def to_str
    "number: '#{@number}'"
  end

  private
  # это низкоуровневый метод, который знает некоторые делаи реализации
  # которые не должен быть доступет вызывающему коду
  def go_to_station(station)
    @current_station.handle_departure(self)
    station.handle_arrival(self)
    @current_station = station
  end

  def validate
    raise "Invalid train number. Desired format xxx[-]xx (where x is any letter or number)" if @number !~ NUMBER_FORMAT
    raise "Invalid train type provided. Allowed types: #{TYPES.join(", ")}." unless TYPES.include?(@type)
    raise "Speed cannot be negative." if @speed.negative?
  end
end
