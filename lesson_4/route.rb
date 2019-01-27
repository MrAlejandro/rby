class Route
  attr_reader :initial_station, :stations

  def initialize(initial_station, terminal_station)
    @initial_station = initial_station
    @terminal_station = terminal_station
    @stations = [initial_station, terminal_station]
  end

  def add_station(station)
    already_exists = @initial_station == station || @terminal_station == station || @stations.include?(station)
    @stations.insert(-2, station) unless already_exists
    self
  end

  def remove_station(station)
    is_edge_station = station == @initial_station || station == @terminal_station
    can_remove = !is_edge_station && !station.has_trains?
    @stations.delete(station) if can_remove
  end

  def print_stations
    @stations.each { |station| puts station.to_str }
  end

  def get_station_after(station)
    station_index = @stations.index(station)
    station_index ? @stations[station_index+1] : nil
  end

  def get_station_before(station)
    station_index = @stations.index(station)
    station_index && station_index > 0 ? @stations[station_index-1] : nil
  end

  def to_str
    @stations.map{ |station| station.to_str }.join(' - ')
  end
end
