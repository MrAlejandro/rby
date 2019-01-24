require './lesson_3/station.rb'

uly = Station.new("Ulyanovsk")
sm = Station.new("Samara")
kz = Station.new("Kazan")
msk = Station.new("Moscow")

uly_msk_route = Route.new(uly, msk)
uly_msk_route.add_station(sm)
uly_msk_route.add_station(kz)
# uly_msk_route.print_stations

uly_msk_cargo_train = Train.new("uly_msk_01", "cargo", 7)
uly_msk_pass_train1 = Train.new("uly_msk_02", "passenger", 9)
uly_msk_pass_train2 = Train.new("uly_msk_03", "passenger", 9)

uly_kz_cargo_train = Train.new("uly_kz_01", "cargo", 3)
uly_kz_pass_train = Train.new("uly_kz_02", "passenger", 5)

uly_msk_cargo_train.route = uly_msk_route
puts uly.get_trains_quantity_by_type("cargo")

uly_msk_pass_train1.route = uly_msk_route
uly_msk_pass_train2.route = uly_msk_route
puts uly.get_trains_quantity_by_type("passenger")

uly_msk_pass_train1.go_forward
puts uly.get_trains_quantity_by_type("passenger")
puts sm.get_trains_quantity_by_type("passenger")

uly_msk_pass_train1.go_forward
puts uly.get_trains_quantity_by_type("passenger")
puts sm.get_trains_quantity_by_type("passenger")
puts kz.get_trains_quantity_by_type("passenger")
uly_msk_pass_train1.go_back
uly_msk_pass_train1.go_back

# puts uly.get_trains_quantity_by_type("passenger")
# uly.handle_departure(uly_msk_pass_train2)
# puts uly.get_trains_quantity_by_type("passenger")
