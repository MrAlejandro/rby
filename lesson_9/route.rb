class Route
  include InstanceCounter

  attr_reader :initial_station, :stations

  def initialize(initial_station, terminal_station)
    @initial_station = initial_station
    @terminal_station = terminal_station
    @stations = [initial_station, terminal_station]
    validate
    register_instance
  end

  def valid?
    validate
    true
  rescue StandardError
    false
  end

  def add_station(station)
    can_add = station.is_a?(Station) && @stations.none? { |st| st == station }
    @stations.insert(-2, station) if can_add
    self
  end

  def remove_station(station)
    is_edge_station = [@initial_station, @terminal_station].include?(station)
    cannot_remove = is_edge_station && station.trains?
    @stations.delete(station) unless cannot_remove
  end

  def print_stations
    @stations.each { |station| puts station.to_str }
  end

  def get_station_after(station)
    station_index = @stations.index(station)
    @stations[station_index + 1] || nil
  end

  def get_station_before(station)
    station_index = @stations.index(station)
    station_index && station_index > 0 ? @stations[station_index - 1] : nil
  end

  def to_str
    @stations.map(&:to_str).join(' - ')
  end

  protected

  def validate
    nowhere_route = @initial_station == @terminal_station
    raise 'Initial and terminal station cannot be equal.' if nowhere_route
    raise 'Initial number of stations in the route.' if @stations.size < 2

    all_stations_valid = @stations.all? { |st| st.is_a?(Station) }
    raise 'Item of a wrong type in the stations list.' unless all_stations_valid
  end
end
