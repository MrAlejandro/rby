class Route
  attr_reader :initial_station

  def initialize(initial_station, terminal_station)
    @initial_station = initial_station
    @terminal_station = terminal_station
    @way_stations = []
  end

  def add_station(station)
    already_exists = @initial_station == station || @terminal_station == station || @way_stations.include?(station)
    @way_stations << station unless already_exists
    self
  end

  def remove_station(station)
    @way_stations.delete(station) unless station.has_trains?
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

