class Train
  include Manufacturer
  include InstanceCounter

  TYPES = %i[cargo passenger].freeze
  NUMBER_FORMAT = /^[\w\d]{3}-?[\w\d]{2}$/.freeze

  attr_reader :wagons, :current_station, :number
  attr_accessor :speed

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
  rescue StandardError
    false
  end

  def break
    @speed = 0
  end

  def of_type?(type)
    @type == type
  end

  def wagons_number
    @wagons.size
  end

  def hook_wagon(wagon)
    not_hooked_yet = @wagons.none? { |wg| wg == wagon }
    of_correct_type = wagon.is_a?(Wagon) && wagon.of_type?(@type)
    can_hook = @speed.zero? && not_hooked_yet && of_correct_type
    @wagons << wagon if can_hook
  end

  def unhook_wagon(wagon)
    @wagons.delete(wagon) if @speed.zero?
  end

  def route=(route)
    @route = route
    @current_station = route.initial_station
    route.initial_station.handle_arrival(self)
  end

  def go_forward
    next_station = self.next_station
    go_to_station(next_station) if next_station
  end

  def go_back
    prev_station = self.prev_station
    go_to_station(prev_station) if prev_station
  end

  def next_station
    @route.get_station_after(@current_station)
  end

  def prev_station
    @route.get_station_before(@current_station)
  end

  def each_wagon(&block)
    if block.arity == 2
      @wagons.each_with_index { |wagon, index| yield index, wagon }
    else
      @wagons.each { |wagon| yield wagon }
    end
  end

  def to_str
    "number: '#{@number}', number of wagons: #{wagons_number}"
  end

  private

  def go_to_station(station)
    @current_station.handle_departure(self)
    station.handle_arrival(self)
    @current_station = station
  end

  def validate
    raise 'Speed cannot be negative.' if @speed.negative?

    invalid_number = @number !~ NUMBER_FORMAT
    if invalid_number
      raise 'Invalid train number. Desired format xxx[-]xx '\
            '(where x is any letter or number)'
    end

    unless TYPES.include?(@type)
      raise 'Invalid train type provided. '\
            "Allowed types: #{TYPES.join(', ')}."
    end
  end
end
