class Station
  attr_reader :trains

  def initialize(name)
    @name = name
    @trains = []
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

  def to_str
    @name
  end
end

class Route
  attr_reader :initial_station

  def initialize(initial_station, terminal_station)
    @initial_station = initial_station
    @terminal_station = terminal_station
    @way_stations = []
  end

  def add_station(station)
    @way_stations << station
    self
  end

  def remove_station(station)
    @way_stations.delete(station)
  end

  def print_stations
    get_all_stations.each { |station| puts station.to_str }
  end

  def get_station_after(station)
    station_index = get_index_of_station(station)
    station_index ? get_all_stations[station_index+1] : nil
  end

  def get_station_before(station)
    station_index = get_index_of_station(station)
    station_index && station_index > 0 ? get_all_stations[station_index-1] : nil
  end

  private
  def get_all_stations
    [@initial_station, @way_stations, @terminal_station].flatten
  end

  def get_index_of_station(station)
    get_all_stations.find_index(station)
  end
end

class Train
  attr_reader :cars_number
  attr_reader :current_station
  attr_accessor :speed

  def initialize(number, type, cars_number)
    @number = number
    @type = type
    @cars_number = cars_number
    @speed = 0
    @current_station = nil
  end

  def break
    @speed = 0
  end

  def hook_car
    @cars_number += 1 if @speed == 0
  end

  def unhook_car
    @cars_number -= 1 if @speed == 0 && cars_number > 0
  end

  def route=(route)
    @route = route
    @current_station = route.initial_station
    route.initial_station.handle_arrival(self)
  end

  def is_of_type?(type)
    @type == type
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

  private
  def go_to_station(station)
    @current_station.handle_departure(self)
    station.handle_arrival(self)
    @current_station = station
  end
end
