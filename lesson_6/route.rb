class Route
  attr_reader :initial_station, :stations

  include InstanceCounter

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
  rescue
    false
  end

  def add_station(station)
    @stations.insert(-2, station) if station.is_a?(Station) && @stations.none? {|st| st == station}
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
    @stations.map {|station| station.to_str}.join(' - ')
  end

  protected

  def validate
    raise "Initial station cannot be equal to terminal station." if @initial_station == @terminal_station
    raise "Initial number of stations in the route." if @stations.size < 2
    raise "Item of a wrong type in the stations list." unless @stations.all? {|st| st.is_a?(Station)}
  end
end
