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
