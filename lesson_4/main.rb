require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'station'
require_relative 'route'
require_relative 'car'

CODE_OK = 0
CODE_EXIT = -1
CODE_ERROR = 1

stations = []
trains = []
routes = []

def prompt_select_train(message, trains)
  puts message
  trains.each_with_index {|train, index| puts "#{index}: #{train.to_str}"}
  train_index = gets.to_i
  trains[train_index]
end

def prompt_select_station(message, stations)
  puts message
  stations.each_with_index {|station, index| puts "#{index}: #{station.to_str}"}
  station_index = gets.to_i
  stations[station_index]
end

def prompt_select_route(message, routes)
  puts message
  routes.each_with_index {|route, index| puts "#{index}: #{route.to_str}"}
  route_index = gets.to_i
  routes[route_index]
end

stop = lambda do
  CODE_EXIT
end

create_station = lambda do
  puts "Enter station name: "
  station_name = gets.chomp
  stations << Station.new(station_name)
  puts "New station '#{station_name}' has been added"
end

create_train = lambda do
  types = [:Passenger, :Cargo]

  puts "Select type:"
  types.each_with_index {|type, index| puts "#{index} - #{type}"}
  type = gets.to_i
  return CODE_ERROR unless types[type]

  puts "Enter train number: "
  number = gets.chomp
  return CODE_ERROR if number.empty?

  case type
  when 0
    trains << PassengerTrain.new(number)
    puts "New passenger train with number '#{number}' has been created"
  when 1
    trains << CargoTrain.new(number)
    puts "New cargo train with number '#{number}' has been created"
  else
    return CODE_ERROR
  end

  CODE_OK
end

hook_car = lambda do
  train = prompt_select_train("Select train: ", trains)
  return CODE_ERROR unless train

  train.hook_car(train.is_of_type?(:cargo) ? Car.new(:cargo) : Car.new(:passenger))
  puts "The car has been hooked to the train. Number of cars: #{train.cars_number}"
  CODE_OK
end

unhook_car = lambda do
  train = prompt_select_train("Select train: ", trains)
  return CODE_ERROR unless train

  puts "Select car to bo unhooked: "
  train.cars.each_index {|index| puts "#{index}: car number #{index + 1}"}
  car_index = gets.to_i
  car = train.cars[car_index]
  return CODE_ERROR unless car

  train.unhook_car(car)
  puts "The car has been unhooked from the train. Number of cars: #{train.cars_number}"
  CODE_OK
end

create_route = lambda do
  initial_station = prompt_select_station("Select initial station: ", stations)
  return CODE_ERROR unless initial_station

  terminal_station = prompt_select_station("Select terminal station: ", stations)
  return CODE_ERROR unless terminal_station

  route = Route.new(terminal_station, initial_station)
  routes << route
  puts "A new route '#{route.to_str}' has been created"
  CODE_OK
end

add_station_to_route = lambda do
  route = prompt_select_route("Select route: ", routes)
  return CODE_ERROR unless route

  station = prompt_select_station("Select station to be added: ", stations)
  return CODE_ERROR unless station

  route.add_station(station)
  puts "Route has been modified #{route.to_str}"
  CODE_OK
end

remove_station_from_route = lambda do
  route = prompt_select_route("Select route: ", routes)
  return CODE_ERROR unless route

  station_to_delete = prompt_select_station("Select station to delete: ", stations)
  return CODE_ERROR unless station_to_delete

  route.remove_station(station_to_delete)
  puts "Route has been modified #{route.to_str}"
  CODE_OK
end

assign_route_to_train = lambda do
  train = prompt_select_train("Select train: ", trains)
  return CODE_ERROR unless train

  route = prompt_select_route("Select route: ", routes)
  return CODE_ERROR unless route

  train.route = route
  puts "The route: #{route.to_str} has been assigned to train: #{train.to_str}"
  CODE_OK
end

move_train_forward = lambda do
  train = prompt_select_train("Select train: ", trains)
  return CODE_ERROR unless train

  train.go_forward
  puts "Train's current station is #{train.current_station.to_str}."
end

move_train_back = lambda do
  train = prompt_select_train("Select train: ", trains)
  return CODE_ERROR unless train

  train.go_back
  puts "Train's current station is #{train.current_station.to_str}."
end

print_stations_list = lambda do
  stations.each {|station| puts station.to_str}
end

print_trains_on_station = lambda do
  station = prompt_select_station("Select station: ", stations)
  return CODE_ERROR unless station

  station.trains.each {|train| puts train.to_str}
end

commands = [
    {title: "Exit", handler: stop},
    {title: "Create station", handler: create_station},
    {title: "Create train", handler: create_train},
    {title: "Create route", handler: create_route},
    {title: "Add station to route", handler: add_station_to_route},
    {title: "Remove station from route", handler: remove_station_from_route},
    {title: "Assign route to train", handler: assign_route_to_train},
    {title: "Hook car", handler: hook_car},
    {title: "Unhook car", handler: unhook_car},
    {title: "Move train forward", handler: move_train_forward},
    {title: "Move train back", handler: move_train_back},
    {title: "Print stations list", handler: print_stations_list},
    {title: "Print trains on station", handler: print_trains_on_station},
]


loop do
  puts "Select action:"
  commands.each_with_index {|action, index| puts "#{index}: #{action[:title]}"}

  action = gets.to_i
  result = commands[action] ? commands[action][:handler].call : CODE_ERROR

  case result
  when CODE_EXIT
    puts "Good bye!"
    break
  when CODE_ERROR
    puts "Error occurred"
  else
    puts "Success"
  end
end
