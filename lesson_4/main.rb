require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class RailWayControlPanel
  OPERATION_CODE_OK = 0
  OPERATION_CODE_EXIT = -1
  OPERATION_CODE_ERROR = 1

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end
  
  def stop
    OPERATION_CODE_EXIT
  end

  def create_station
    puts "Enter station name: "
    station_name = gets.chomp
    @stations << Station.new(station_name)
    puts "New station '#{station_name}' has been added"
  end

  def create_train
    types = [:Passenger, :Cargo]

    puts "Select type:"
    types.each_with_index {|type, index| puts "#{index} - #{type}"}
    type = gets.to_i
    return OPERATION_CODE_ERROR unless types[type]

    puts "Enter train number: "
    number = gets.chomp
    return OPERATION_CODE_ERROR if number.empty?

    case type
    when 0
      @trains << PassengerTrain.new(number)
      puts "New passenger train with number '#{number}' has been created"
    when 1
      @trains << CargoTrain.new(number)
      puts "New cargo train with number '#{number}' has been created"
    else
      return OPERATION_CODE_ERROR
    end

    OPERATION_CODE_OK
  end

  def hook_wagon
    train = prompt_select_train("Select train: ")
    return OPERATION_CODE_ERROR unless train

    train.hook_wagon(train.is_of_type?(:cargo) ? CargoWagon.new : PassengerWagon.new)
    puts "The wagon has been hooked to the train. Number of cars: #{train.wagon_number}"
    OPERATION_CODE_OK
  end

  def unhook_wagon
    train = prompt_select_train("Select train: ")
    return OPERATION_CODE_ERROR unless train

    puts "Select wagon to be unhooked: "
    train.wagons.each_index {|index| puts "#{index}: wagon number #{index + 1}"}
    wagon_index = gets.to_i
    wagon = train.wagons[wagon_index]
    return OPERATION_CODE_ERROR unless wagon

    train.unhook_wagon(wagon)
    puts "The wagon has been unhooked from the train. Number of wagons: #{train.wagon_number}"
    OPERATION_CODE_OK
  end

  def create_route
    initial_station = prompt_select_station("Select initial station: ")
    return OPERATION_CODE_ERROR unless initial_station

    terminal_station = prompt_select_station("Select terminal station: ")
    return OPERATION_CODE_ERROR unless terminal_station

    route = Route.new(initial_station, terminal_station)
    @routes << route
    puts "A new route '#{route.to_str}' has been created"
    OPERATION_CODE_OK
  end

  def add_station_to_route
    route = prompt_select_route("Select route: ")
    return OPERATION_CODE_ERROR unless route

    station = prompt_select_station("Select station to be added: ")
    return OPERATION_CODE_ERROR unless station

    route.add_station(station)
    puts "Route has been modified #{route.to_str}"
    OPERATION_CODE_OK
  end

  def remove_station_from_route
    route = prompt_select_route("Select route: ")
    return OPERATION_CODE_ERROR unless route

    station_to_delete = prompt_select_station("Select station to delete: ", route.stations[1..-2])
    return OPERATION_CODE_ERROR unless station_to_delete

    route.remove_station(station_to_delete)
    puts "Route has been modified #{route.to_str}"
    OPERATION_CODE_OK
  end

  def assign_route_to_train
    train = prompt_select_train("Select train: ")
    return OPERATION_CODE_ERROR unless train

    route = prompt_select_route("Select route: ")
    return OPERATION_CODE_ERROR unless route

    train.route = route
    puts "The route: #{route.to_str} has been assigned to train: #{train.to_str}"
    OPERATION_CODE_OK
  end

  def move_train_forward
    train = prompt_select_train("Select train: ")
    return OPERATION_CODE_ERROR unless train

    train.go_forward
    puts "Train's current station is #{train.current_station.to_str}."
  end

  def move_train_back
    train = prompt_select_train("Select train: ")
    return OPERATION_CODE_ERROR unless train

    train.go_back
    puts "Train's current station is #{train.current_station.to_str}."
  end

  def print_stations_list
    @stations.each {|station| puts station.to_str}
  end

  def print_trains_on_station
    station = prompt_select_station("Select station: ")
    return OPERATION_CODE_ERROR unless station

    station.trains.each {|train| puts train.to_str}
  end

  private
  # это внутрееные методы, которые не должны быть доступны во внешнем интерфейсе
  def prompt_select_train(message, trains = @trains)
    puts message
    trains.each_with_index {|train, index| puts "#{index}: #{train.to_str}"}
    train_index = gets.to_i
    trains[train_index]
  end

  def prompt_select_station(message, stations = @stations)
    puts message
    stations.each_with_index {|station, index| puts "#{index}: #{station.to_str}"}
    station_index = gets.to_i
    stations[station_index]
  end

  def prompt_select_route(message, routes = @routes)
    puts message
    routes.each_with_index {|route, index| puts "#{index}: #{route.to_str}"}
    route_index = gets.to_i
    routes[route_index]
  end
end

rwcp = RailWayControlPanel.new

commands = [
    {title: "Exit", handler: rwcp.method(:stop)},
    {title: "Create station", handler: rwcp.method(:create_station)},
    {title: "Create train", handler: rwcp.method(:create_train)},
    {title: "Create route", handler: rwcp.method(:create_route)},
    {title: "Add station to route", handler: rwcp.method(:add_station_to_route)},
    {title: "Remove station from route", handler: rwcp.method(:remove_station_from_route)},
    {title: "Assign route to train", handler: rwcp.method(:assign_route_to_train)},
    {title: "Hook wagon", handler: rwcp.method(:hook_wagon)},
    {title: "Unhook wagon", handler: rwcp.method(:unhook_wagon)},
    {title: "Move train forward", handler: rwcp.method(:move_train_forward)},
    {title: "Move train back", handler: rwcp.method(:move_train_back)},
    {title: "Print stations list", handler: rwcp.method(:print_stations_list)},
    {title: "Print trains on station", handler: rwcp.method(:print_trains_on_station)},
]

loop do
  puts "Select action:"
  commands.each_with_index {|action, index| puts "#{index}: #{action[:title]}"}

  action = gets.to_i
  result = commands[action] ? commands[action][:handler].call : OPERATION_CODE_ERROR

  case result
  when RailWayControlPanel::OPERATION_CODE_EXIT
    puts "Good bye!"
    break
  when RailWayControlPanel::OPERATION_CODE_ERROR
    puts "Error occurred"
  else
    puts "Success"
  end
end
