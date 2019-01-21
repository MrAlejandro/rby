puts "What's your name? "
name = gets.chomp

puts "What's your height? "
height = gets.chomp.to_f

puts "What's your weight"
weight = gets.chomp.to_f

ideal_weight = height - 110
if ideal_weight < weight
  puts "#{name}, your ideal weight is #{ideal_weight.round(2)}"
else
  puts "Your weight is already optimal"
end
