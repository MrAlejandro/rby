require_relative 'instance_counter'
require_relative 'manufacturer'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class RailwayNotInitializedError < RuntimeError; end
class RailwayWrongInputError < RuntimeError; end
class RailwayTerminateError < RuntimeError; end

class RailWayControlPanel
  TRAIN_TYPES = [:Cargo, :Passenger]

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
    init_commands
  end

  def start
    loop do
      begin
        action = prompt_select_action("Select action:")
      rescue RailwayWrongInputError => e
        puts e.message
        retry
      end

      begin
        result = action[:handler].call
        puts result
      rescue RailwayTerminateError  => e
        puts e.message
        break
      rescue RailwayNotInitializedError  => e
        puts e.message
      rescue RailwayWrongInputError, RuntimeError => e
        puts e.message
        retry
      end
    end
  end

  private

  # следующие методы не очень полезны вне контекста класса
  def stop
    raise RailwayTerminateError, "Good bue!"
  end

  def seed
    st1 = Station.new("Uly")
    st2 = Station.new("Msk")
    st3 = Station.new("NY")
    @stations = [st1, st2, st3]

    rt1 = Route.new(st1, st3)
    rt1.add_station(st2)
    @routes = [rt1]

    pt1 = PassengerTrain.new("aaa-aa")
    pt1.hook_wagon(reserve_seats(33, PassengerWagon.new(55)))
    pt1.hook_wagon(reserve_seats(33, PassengerWagon.new(33)))
    pt1.hook_wagon(reserve_seats(55, PassengerWagon.new(77)))

    pt2 = PassengerTrain.new("bbb-bb")
    pt2.hook_wagon(reserve_seats(11, PassengerWagon.new(33)))

    pt3 = PassengerTrain.new("ccc-dd")
    pt3.hook_wagon(reserve_seats(22, PassengerWagon.new(33)))
    pt3.hook_wagon(reserve_seats(22, PassengerWagon.new(55)))

    pt1.route = rt1
    pt2.route = rt1
    pt3.route = rt1

    ct1 = CargoTrain.new("eee-ee")
    ct1.hook_wagon(reserve_volume([10, 30, 40], CargoWagon.new(100)))
    ct1.hook_wagon(reserve_volume([20, 30, 40], CargoWagon.new(100)))
    ct1.hook_wagon(reserve_volume([30, 30, 40], CargoWagon.new(100)))

    ct2 = CargoTrain.new("fff-ff")
    ct2.hook_wagon(reserve_volume([30, 40], CargoWagon.new(100)))
    ct2.hook_wagon(reserve_volume([20, 40], CargoWagon.new(100)))

    ct3 = CargoTrain.new("ggg-gg")
    ct3.hook_wagon(reserve_volume([20, 30], CargoWagon.new(100)))
    ct1.hook_wagon(reserve_volume([70, 30], CargoWagon.new(100)))

    ct1.route = rt1
    ct2.route = rt1
    ct3.route = rt1

    @trains = [pt1, pt2, pt3, ct1, ct2, ct3]
    puts "Demo data has been generated."
  end

  def create_station
    puts "Enter station name: "
    station_name = gets.chomp
    @stations << Station.new(station_name)
    "New station '#{station_name}' has been added"
  end

  def create_train
    puts "Select type:"
    TRAIN_TYPES.each_with_index {|type, index| puts "#{index} - #{type}"}
    type = gets.to_i

    puts "Enter train number: "
    number = gets.chomp

    case type
    when 0
      @trains << PassengerTrain.new(number)
      result = "New passenger train with number '#{number}' has been created"
    when 1
      @trains << CargoTrain.new(number)
      result = "New cargo train with number '#{number}' has been created"
    else
      raise RailwayWrongInputError, "You have selected non existing type."
    end

    result
  end

  def create_wagon
    puts "Select type:"
    TRAIN_TYPES.each_with_index {|type, index| puts "#{index} - #{type}"}
    type = gets.to_i

    case type
    when 0
      puts "Enter number of seats: "
      seats_number = gets.to_i
      @wagons << PassengerWagon(seats_number)
    when 1
      puts "Enter wagon volume: "
      volume = gets.to_f
      @wagons << CargoWagon(volume)
    else
      raise RailwayWrongInputError, "You have selected non existing type."
    end
  end

  def hook_wagon
    train = prompt_select_train("Select train: ")

    train.hook_wagon(train.is_of_type?(:cargo) ? CargoWagon.new : PassengerWagon.new)
    "The wagon has been hooked to the train. Number of cars: #{train.wagon_number}"
  end

  def unhook_wagon
    train = prompt_select_train("Select train: ")
    raise RailwayNotInitializedError, "Selected train does not have any wagon yet." if train..wagons.size.zero?

    puts "Select wagon to be unhooked: "
    train.wagons.each_index {|index| puts "#{index}: wagon number #{index + 1}"}
    wagon_index = gets.to_i
    wagon = train.wagons[wagon_index]
    raise RailwayWrongInputError, "You have selected non existent wagon." unless wagon

    train.unhook_wagon(wagon)
    "The wagon has been unhooked from the train. Number of wagons: #{train.wagon_number}"
  end

  def create_route
    initial_station = prompt_select_station("Select initial station: ")
    terminal_station = prompt_select_station("Select terminal station: ")

    route = Route.new(initial_station, terminal_station)
    @routes << route
    "A new route '#{route.to_str}' has been created"
  end

  def add_station_to_route
    route = prompt_select_route("Select route: ")
    station = prompt_select_station("Select station to be added: ")

    route.add_station(station)
    "Route has been modified #{route.to_str}"
  end

  def remove_station_from_route
    route = prompt_select_route("Select route: ")
    station_to_delete = prompt_select_station("Select station to delete: ", route.stations[1..-2])

    route.remove_station(station_to_delete)
    "Route has been modified #{route.to_str}"
  end

  def assign_route_to_train
    train = prompt_select_train("Select train: ")
    route = prompt_select_route("Select route: ")

    train.route = route
    "The route: #{route.to_str} has been assigned to train: #{train.to_str}"
  end

  def move_train_forward
    train = prompt_select_train("Select train: ")
    train.go_forward
    "Train's current station is #{train.current_station.to_str}."
  end

  def move_train_back
    train = prompt_select_train("Select train: ")
    train.go_back
    "Train's current station is #{train.current_station.to_str}."
  end

  def print_stations_list
    @stations.each {|station| puts station.to_str}
    "Success"
  end

  def print_trains_on_station
    station = prompt_select_station("Select station: ")
    station.trains.each {|train| puts train.to_str}
    "Success"
  end

  # это внутрееные методы, которые не должны быть доступны во внешнем интерфейсе
  def prompt_select_train(message, trains = @trains)
    raise RailwayNotInitializedError, "You have not created any trains yet." if trains.size.zero?

    puts message
    trains.each_with_index {|train, index| puts "#{index}: #{train.to_str}"}
    train_index = gets.to_i
    train = trains[train_index]

    raise RailwayWrongInputError, "You have selected non existent train." unless train
    train
  end

  def prompt_select_station(message, stations = @stations)
    raise RailwayNotInitializedError, "You have not created any stations yet." if stations.size.zero?

    puts message
    stations.each_with_index {|station, index| puts "#{index}: #{station.to_str}"}
    station_index = gets.to_i
    station = stations[station_index]

    raise RailwayWrongInputError, "You have selected non existent station." unless station
    station
  end

  def prompt_select_route(message, routes = @routes)
    raise RailwayNotInitializedError, "You have not created any routes yet." if routes.size.zero?

    puts message
    routes.each_with_index {|route, index| puts "#{index}: #{route.to_str}"}
    route_index = gets.to_i
    route = routes[route_index]

    raise RailwayWrongInputError, "You have selected non existent route." unless route
    route
  end

  def prompt_select_action(message, commands = @commands)
    commands.each_with_index {|action, index| puts "#{index}: #{action[:title]}"}
    command_index = gets.to_i
    raise RailwayWrongInputError, "You have selected non existing action." unless @commands[command_index]
    @commands[command_index]
  end

  def init_commands
    @commands = [
        {title: "Exit", handler: self.method(:stop)},
        {title: "Fill demo data", handler: self.method(:seed)},
        {title: "Create station", handler: self.method(:create_station)},
        {title: "Create train", handler: self.method(:create_train)},
        {title: "Create route", handler: self.method(:create_route)},
        {title: "Create wagon", handler: self.method(:create_wagon)},
        {title: "Add station to route", handler: self.method(:add_station_to_route)},
        {title: "Remove station from route", handler: self.method(:remove_station_from_route)},
        {title: "Assign route to train", handler: self.method(:assign_route_to_train)},
        {title: "Hook wagon", handler: self.method(:hook_wagon)},
        {title: "Unhook wagon", handler: self.method(:unhook_wagon)},
        {title: "Move train forward", handler: self.method(:move_train_forward)},
        {title: "Move train back", handler: self.method(:move_train_back)},
        {title: "Print stations list", handler: self.method(:print_stations_list)},
        {title: "Print trains on station", handler: self.method(:print_trains_on_station)},
    ]
  end

  def reserve_seats(n, wagon)
    while n > 0 do
      wagon.reserve_seat
      n -= 1
    end
    wagon
  end

  def reserve_volume(volumes, wagon)
    volumes.each {|volume| wagon.reserve_volume(volume)}
    wagon
  end
end

rwcp = RailWayControlPanel.new
rwcp.start
